import '../models/visita_model.dart';
import 'api_service.dart';

class VisitaService {
  final ApiService _api = ApiService();

  Future<List<VisitaModel>> listarVisitas() async {
    final data = await _api.get('/visitas');

    return (data as List)
        .map((json) => VisitaModel.fromJson(json))
        .toList();
  }

  Future<void> adicionarVisita(VisitaModel visita) async {
    await _api.post('/visitas', visita.toJson());
  }

  Future<void> atualizarVisita(VisitaModel visitaAtualizada) async {
    await _api.put('/visitas/${visitaAtualizada.id}', visitaAtualizada.toJson());
  }

  Future<void> excluirVisita(int id) async {
    await _api.delete('/visitas/$id');
  }
}