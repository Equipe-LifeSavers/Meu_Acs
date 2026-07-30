class AcsModel {
  final int id;
  final String nome;

  const AcsModel({required this.id, required this.nome});

  factory AcsModel.fromJson(Map<String, dynamic> json) {
    return AcsModel(
      id: json['id'],
      nome: json['nome'] ?? '',
    );
  }
}