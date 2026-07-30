class RegiaoModel {
  final int id;
  final String nomeArea;

  const RegiaoModel({required this.id, required this.nomeArea});

  factory RegiaoModel.fromJson(Map<String, dynamic> json) {
    return RegiaoModel(
      id: json['id'],
      nomeArea: json['nomeArea'] ?? '',
    );
  }
}