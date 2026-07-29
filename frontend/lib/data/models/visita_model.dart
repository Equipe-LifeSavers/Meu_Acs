class VisitaModel {
  final int id;
  final String familia;
  final String agente;
  final DateTime data;
  final String tipoVisita;
  final String observacao;
  final String status;

  const VisitaModel({
    required this.id,
    required this.familia,
    required this.agente,
    required this.data,
    required this.tipoVisita,
    required this.observacao,
    required this.status,
  });
}
