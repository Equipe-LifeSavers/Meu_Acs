class VisitaModel {
  final int id;
  final String familia;
  final String agente;
  final DateTime data;
  final String tipoVisita;
  final String observacao;
  final String status;

  // Necessários para criar/atualizar.
  final int? moradorId;
  final int? acsId;

  const VisitaModel({
    required this.id,
    required this.familia,
    required this.agente,
    required this.data,
    required this.tipoVisita,
    required this.observacao,
    required this.status,
    this.moradorId,
    this.acsId,
  });

  factory VisitaModel.fromJson(Map<String, dynamic> json) {
    return VisitaModel(
      id: json['id'],
      // o backend não devolve o nome da família na visita, só do morador.
      familia: json['nomeMorador'] ?? '',
      agente: json['nomeAcs'] ?? '',
      data: DateTime.parse(json['data']),
      tipoVisita: json['demanda'] ?? '',
      observacao: json['observacoes'] ?? '',
      status: (json['visitaRealizada'] == true) ? 'Realizada' : 'Pendente',
      moradorId: json['moradorId'],
      acsId: json['acsId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moradorId': moradorId,
      'acsId': acsId,
      'data': data.toIso8601String().split('T').first,
      'observacoes': observacao,
      'demanda': tipoVisita,
      'visitaRealizada': status == 'Realizada',
    };
  }
}
