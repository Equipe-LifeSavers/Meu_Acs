import '../models/morador_model.dart';
import 'api_service.dart';

class MoradorService {
  final ApiService _api = ApiService();

  Future<List<MoradorModel>> listarMoradores() async {
    final data = await _api.get('/moradores');

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
