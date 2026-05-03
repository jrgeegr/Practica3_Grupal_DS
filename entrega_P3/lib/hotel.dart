import 'servicio_turistico.dart';
import 'politica_hotel.dart';

class Hotel implements ServicioTuristico {
  String nombre;
  double precioNoche;
  int noches;
  PoliticaHotel politica;

  Hotel(this.nombre, this.precioNoche, this.noches, this.politica) {
    if (noches <= 0) throw ArgumentError("Las noches deben ser mayores a cero");
  }

  @override
  double getPrecio() => politica.calcular(precioNoche, noches);

  Hotel copy() => Hotel(nombre, precioNoche, noches, politica);
}