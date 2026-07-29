class RelatorioModel {
  final int id;
  final String regiao;
  final String ubs;
  final int totalAcs;
  final int totalResidencias;
  final int totalFamilias;
  final int totalMoradores;
  final int totalVisitas;
  final int visitasRealizadas;
  final int visitasPendentes;

  const RelatorioModel({
    required this.id,
    required this.regiao,
    required this.ubs,
    required this.totalAcs,
    required this.totalResidencias,
    required this.totalFamilias,
    required this.totalMoradores,
    required this.totalVisitas,
    required this.visitasRealizadas,
    required this.visitasPendentes,
  });

  factory RelatorioModel.fromJson(Map<String, dynamic> json) {
    return RelatorioModel(
      id: json['id'],
      regiao: json['nomeArea'],
      ubs: json['ubsNome'],
      totalAcs: json['totalAcs'],
      totalResidencias: json['totalResidencias'],
      totalFamilias: json['totalFamilias'],
      totalMoradores: json['totalMoradores'],
      totalVisitas: json['totalVisitas'],
      visitasRealizadas: json['visitasRealizadas'],
      visitasPendentes: json['visitasPendentes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomeArea': regiao,
      'ubsNome': ubs,
      'totalAcs': totalAcs,
      'totalResidencias': totalResidencias,
      'totalFamilias': totalFamilias,
      'totalMoradores': totalMoradores,
      'totalVisitas': totalVisitas,
      'visitasRealizadas': visitasRealizadas,
      'visitasPendentes': visitasPendentes,
    };
  }
}
