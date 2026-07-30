import '../models/relatorio_model.dart';
import 'api_service.dart';
import '../../core/utils/download_helper.dart';

class RelatorioService {
  final ApiService _api = ApiService();

  Future<List<RelatorioModel>> listarRelatorios() async {
    final data = await _api.get('/relatorios/regioes');

    return (data as List)
        .map((json) => RelatorioModel.fromJson(json))
        .toList();
  }

  Future<void> gerarRelatorioGeral() async {
    final bytes = await _api.getBytes('/relatorios/regioes/pdf');
    baixarArquivo(bytes, 'relatorio-regioes.pdf');
  }

  Future<void> gerarRelatorioPorRegiao(int regiaoId) async {
    final bytes = await _api.getBytes('/relatorios/regioes/$regiaoId/pdf');
    baixarArquivo(bytes, 'relatorio-regiao-$regiaoId.pdf');
  }
}