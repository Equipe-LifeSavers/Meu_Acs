import '../models/relatorio_model.dart';
import 'api_service.dart';

class RelatorioService {
  final ApiService _api = ApiService();

  Future<List<RelatorioModel>> listarRelatorios() async {
    final data = await _api.get('/relatorios/regioes');

    return (data as List)
        .map((json) => RelatorioModel.fromJson(json))
        .toList();
  }

  Future<void> gerarRelatorioGeral() async {
    // GET /relatorios/regioes/pdf
    // Retorna bytes de PDF, não JSON — precisa de tratamento diferente do
    // ApiService (download de arquivo), ainda não implementado.
    throw UnimplementedError('Exportação em PDF ainda não integrada.');
  }

  Future<void> gerarRelatorioPorRegiao(int regiaoId) async {
    // GET /relatorios/regioes/{regiaoId}/pdf
    throw UnimplementedError('Exportação em PDF ainda não integrada.');
  }
}