import 'servicio_turistico.dart';

class Paquete implements ServicioTuristico {
  String nombre;
  List<ServicioTuristico> servicios = [];

  Paquete(this.nombre);

  void agregar(ServicioTuristico servicio) {
    servicios.add(servicio);
  }

  void remover(ServicioTuristico servicio) {
    if(servicios.contains(servicio)) {
      servicios.remove(servicio);
    }
  }

  @override
  double getPrecio() {
    // Suma recursiva de todos los hijos (vuelos, hoteles u otros paquetes)
    return servicios.fold(0, (sum, servicio) => sum + servicio.getPrecio());
  }
}