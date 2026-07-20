class FamiliaModel {
  final int id;
  final String responsavel;
  final String cpfResponsavel;
  final String telefone;
  final String endereco;
  final int quantidadeMoradores;

  const FamiliaModel({
    required this.id,
    required this.responsavel,
    required this.cpfResponsavel,
    required this.telefone,
    required this.endereco,
    required this.quantidadeMoradores,
  });
}
