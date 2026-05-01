import 'servicio_turistico.dart';
import 'politica_vuelo.dart';

class Vuelo implements ServicioTuristico {
  String id;
  double precioBase;
  PoliticaVuelo politica;

  Vuelo(this.id, this.precioBase, this.politica) {
    if (precioBase < 0) throw ArgumentError("El precio base no puede ser negativo");
  }

  @override
  double getPrecio() => politica.calcular(precioBase);
}