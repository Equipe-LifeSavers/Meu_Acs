import '../models/relatorio_model.dart';

class RelatorioMock {
  static final List<RelatorioModel> relatorios = [
    const RelatorioModel(
      id: 1,
      regiao: 'Área Centro',
      ubs: 'UBS Centro',
      totalAcs: 4,
      totalResidencias: 248,
      totalFamilias: 236,
      totalMoradores: 984,
      totalVisitas: 415,
      visitasRealizadas: 387,
      visitasPendentes: 28,
    ),

    const RelatorioModel(
      id: 2,
      regiao: 'Área Norte',
      ubs: 'UBS Centro',
      totalAcs: 3,
      totalResidencias: 192,
      totalFamilias: 180,
      totalMoradores: 731,
      totalVisitas: 296,
      visitasRealizadas: 281,
      visitasPendentes: 15,
    ),

    const RelatorioModel(
      id: 3,
      regiao: 'Área Sul',
      ubs: 'UBS São José',
      totalAcs: 2,
      totalResidencias: 154,
      totalFamilias: 149,
      totalMoradores: 596,
      totalVisitas: 218,
      visitasRealizadas: 210,
      visitasPendentes: 8,
    ),

    const RelatorioModel(
      id: 4,
      regiao: 'Área Rural',
      ubs: 'UBS São José',
      totalAcs: 5,
      totalResidencias: 322,
      totalFamilias: 309,
      totalMoradores: 1284,
      totalVisitas: 487,
      visitasRealizadas: 463,
      visitasPendentes: 24,
    ),
  ];
}
