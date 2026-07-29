import '../../data/models/relatorio_model.dart';
import '../../data/repositories/relatorio_repository.dart';

class RelatorioController {
  final RelatorioRepository _repository = RelatorioRepository();

  Future<List<RelatorioModel>> carregarRelatorios() async {
    return await _repository.listarRelatorios();
  }

  Future<void> gerarRelatorioGeral() async {
    await _repository.gerarRelatorioGeral();
  }

  Future<void> gerarRelatorioPorRegiao(int regiaoId) async {
    await _repository.gerarRelatorioPorRegiao(regiaoId);
  }

  int totalRegioes(List<RelatorioModel> lista) {
    return lista.length;
  }

  int totalAcs(List<RelatorioModel> lista) {
    return lista.fold(0, (total, relatorio) => total + relatorio.totalAcs);
  }

  int totalFamilias(List<RelatorioModel> lista) {
    return lista.fold(0, (total, relatorio) => total + relatorio.totalFamilias);
  }

  int totalMoradores(List<RelatorioModel> lista) {
    return lista.fold(
      0,
      (total, relatorio) => total + relatorio.totalMoradores,
    );
  }

  int totalVisitas(List<RelatorioModel> lista) {
    return lista.fold(0, (total, relatorio) => total + relatorio.totalVisitas);
  }

  int totalVisitasRealizadas(List<RelatorioModel> lista) {
    return lista.fold(
      0,
      (total, relatorio) => total + relatorio.visitasRealizadas,
    );
  }

  int totalVisitasPendentes(List<RelatorioModel> lista) {
    return lista.fold(
      0,
      (total, relatorio) => total + relatorio.visitasPendentes,
    );
  }
}
