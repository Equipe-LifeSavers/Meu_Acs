import '../mocks/relatorio_mock.dart';
import '../models/relatorio_model.dart';

class RelatorioService {
  Future<List<RelatorioModel>> listarRelatorios() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.from(RelatorioMock.relatorios);
  }

  Future<void> gerarRelatorioGeral() async {
    await Future.delayed(const Duration(seconds: 1));

    // GET /relatorios/regioes/pdf
  }

  Future<void> gerarRelatorioPorRegiao(int regiaoId) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // GET /relatorios/regioes/{regiaoId}/pdf
  }
}
