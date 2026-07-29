class DashboardModel {
  final int totalUbs;
  final int totalRegioes;
  final int totalAcs;
  final int totalResidencias;
  final int totalFamilias;
  final int totalMoradores;
  final int totalVisitas;
  final int visitasRealizadas;
  final int visitasPendentes;

  const DashboardModel({
    required this.totalUbs,
    required this.totalRegioes,
    required this.totalAcs,
    required this.totalResidencias,
    required this.totalFamilias,
    required this.totalMoradores,
    required this.totalVisitas,
    required this.visitasRealizadas,
    required this.visitasPendentes,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalUbs: json['totalUbs'] ?? 0,
      totalRegioes: json['totalRegioes'] ?? 0,
      totalAcs: json['totalAcs'] ?? 0,
      totalResidencias: json['totalResidencias'] ?? 0,
      totalFamilias: json['totalFamilias'] ?? 0,
      totalMoradores: json['totalMoradores'] ?? 0,
      totalVisitas: json['totalVisitas'] ?? 0,
      visitasRealizadas: json['visitasRealizadas'] ?? 0,
      visitasPendentes: json['visitasPendentes'] ?? 0,
    );
  }
}