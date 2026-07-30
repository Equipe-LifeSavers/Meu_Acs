import '../models/morador_model.dart';
import 'api_service.dart';
import '../../core/services/session_service.dart';

class MoradorService {
  final ApiService _api = ApiService();

  Future<List<MoradorModel>> listarMoradores() async {
    final endpoint = SessionService.instance.perfil == 'ACS'
        ? '/moradores/minha-regiao'
        : '/moradores';

    final data = await _api.get(endpoint);

    return (data as List)
        .map((json) => MoradorModel.fromJson(json))
        .toList();
  }

  Future<void> adicionarMorador(MoradorModel morador) async {
    await _api.post('/moradores', morador.toJson());
  }

  Future<void> atualizarMorador(MoradorModel morador) async {
    await _api.put('/moradores/${morador.id}', morador.toJson());
  }

  Future<void> excluirMorador(int id) async {
    await _api.delete('/moradores/$id');
  }
}