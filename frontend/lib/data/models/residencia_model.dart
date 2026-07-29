class ResidenciaModel {
  final int id;
  final String familia;
  final String endereco;
  final String tipoImovel;
  final bool possuiAgua;
  final bool possuiEnergia;
  final bool possuiEsgoto;

  const ResidenciaModel({
    required this.id,
    required this.familia,
    required this.endereco,
    required this.tipoImovel,
    required this.possuiAgua,
    required this.possuiEnergia,
    required this.possuiEsgoto,
  });
}
