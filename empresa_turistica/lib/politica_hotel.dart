abstract class PoliticaHotel {
  double calcular(double precioNoche, int noches);
}

class SoloAlojamiento implements PoliticaHotel {
  @override
  double calcular(double precioNoche, int noches) => precioNoche * noches;

  //Tuve que implementar esto debido a un extraño error en la ejecución del main
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SoloAlojamiento;

  @override
  int get hashCode => runtimeType.hashCode;
}

class TodoIncluido implements PoliticaHotel {
  static const double SUPLEMENTO_DIARIO = 40.0; // Restricción: Constante interna

  @override
  double calcular(double precioNoche, int noches) {
    return (precioNoche + SUPLEMENTO_DIARIO) * noches;
  }

  //Tuve que implementar esto debido a un extraño error en la ejecución del main
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TodoIncluido;

  @override
  int get hashCode => runtimeType.hashCode;
}