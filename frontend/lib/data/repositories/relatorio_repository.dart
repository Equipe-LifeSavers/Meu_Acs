import '../models/relatorio_model.dart';
import '../services/relatorio_service.dart';

class RelatorioRepository {
  final RelatorioService _service = RelatorioService();

  Future<List<RelatorioModel>> listarRelatorios() async {
    return await _service.listarRelatorios();
  }

  Future<void> gerarRelatorioGeral() async {
    await _service.gerarRelatorioGeral();
  }

  Future<void> gerarRelatorioPorRegiao(int regiaoId) async {
    await _service.gerarRelatorioPorRegiao(regiaoId);
  }
}
