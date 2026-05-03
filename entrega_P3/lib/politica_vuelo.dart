abstract class PoliticaVuelo {
  double calcular(double base);
}

class TarifaLowCost implements PoliticaVuelo {
  static const double RECARGO_FIJO = 15.0; // Restricción: Constante interna

  @override
  double calcular(double base) => base + RECARGO_FIJO;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TarifaLowCost;

  @override
  int get hashCode => runtimeType.hashCode;
}

class TarifaBusiness implements PoliticaVuelo {
  static const double MULTIPLICADOR = 2.5; // Restricción: Constante interna

  @override
  double calcular(double base) => base * MULTIPLICADOR;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is TarifaBusiness;

  @override
  int get hashCode => runtimeType.hashCode;
}