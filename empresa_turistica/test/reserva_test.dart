import 'package:test/test.dart';
import '../lib/servicio_turistico.dart';
import '../lib/paquete.dart';
import '../lib/vuelo.dart';
import '../lib/politica_vuelo.dart';
import '../lib/hotel.dart';
import '../lib/politica_hotel.dart';

void main() {

  group('Grupo Políticas de Tarifación', () {
    test('TarifaLowCost añade su recargo de gestión constante (15.0) al precio base', () {
      final politica = TarifaLowCost();
      expect(politica.calcular(10.0), equals(25.0));
    });

    test('TarifaBusiness aplica su multiplicador interno (2.5) correctamente', () {
      final politica = TarifaBusiness();
      expect(politica.calcular(10.0), equals(25.0));
    });

    test('RegimenSoloAlojamiento calcula el producto de noches por precio', () {
      final politica = SoloAlojamiento();
      expect(politica.calcular(100.0, 3), equals(300.0));
    });

    test('RegimenTodoIncluido incorpora su suplemento diario (40.0) al coste', () {
      final politica = TodoIncluido();
      expect(politica.calcular(100.0, 2), equals(280.0));
    });
  });

  group('Grupo Servicios Individuales (Hojas)', () {
    test('El constructor de Vuelo lanza excepción ante precio base negativo', () {
      expect(() => Vuelo("V-1", -10.0, TarifaLowCost()), throwsArgumentError);
    });

    test('El constructor de Hotel impide estancias con cero o menos noches', () {
      expect(() => Hotel("H-1", 50.0, 0, SoloAlojamiento()), throwsArgumentError);
    });

    test('El método getPrecio() de Vuelo delega el cálculo en su política', () {
      final vuelo = Vuelo("V-1", 100.0, TarifaBusiness());
      expect(vuelo.getPrecio(), equals(250.0));
    });

    test('El método getPrecio() de Hotel retorna el valor procesado por su régimen', () {
      final hotel = Hotel("H-1", 100.0, 1, TodoIncluido());
      expect(hotel.getPrecio(), equals(140.0));
    });
  });

  group('Grupo Agrupación de Paquetes', () {
    test('Un Paquete recién instanciado sin servicios devuelve cero', () {
      final paquete = Paquete("Vacío");
      expect(paquete.getPrecio(), equals(0.0));
    });

    test('Paquete realiza la suma aritmética de todos sus componentes directos', () {
      final paquete = Paquete("Mix");
      paquete.agregar(Vuelo("V-1", 100.0, TarifaLowCost())); // 115
      paquete.agregar(Hotel("H-1", 100.0, 1, SoloAlojamiento())); // 100
      expect(paquete.getPrecio(), equals(215.0));
    });

    test('La estructura recursiva permite sumar paquetes anidados correctamente', () {
      final paqueteRaiz = Paquete("Raíz");
      final subPaquete = Paquete("Sub");

      subPaquete.agregar(Vuelo("V-1", 100.0, TarifaLowCost())); // 115
      paqueteRaiz.agregar(subPaquete);
      paqueteRaiz.agregar(Hotel("H-1", 100.0, 1, SoloAlojamiento())); // 100

      expect(paqueteRaiz.getPrecio(), equals(215.0));
    });

    test('Cambiar la política de un servicio existente actualiza el total del paquete raíz', () {
      final paqueteRaiz = Paquete("Raíz");
      final vuelo = Vuelo("V-1", 100.0, TarifaBusiness()); // 250
      paqueteRaiz.agregar(vuelo);

      expect(paqueteRaiz.getPrecio(), equals(250.0));

      // Cambio dinámico de política (Strategy)
      vuelo.politica = TarifaLowCost(); // Ahora 115
      expect(paqueteRaiz.getPrecio(), equals(115.0));
    });
  });
}