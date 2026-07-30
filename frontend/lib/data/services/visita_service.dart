import '../models/visita_model.dart';
import 'api_service.dart';
import '../../core/services/session_service.dart';

class VisitaService {
  final ApiService _api = ApiService();

  Future<List<VisitaModel>> listarVisitas() async {
    final endpoint = SessionService.instance.perfil == 'ACS'
        ? '/visitas/minhas'
        : '/visitas';

    final data = await _api.get(endpoint);

    return (data as List)
        .map((json) => VisitaModel.fromJson(json))
        .toList();
  }

  /// Usado no Dashboard para destacar as visitas pendentes do próprio ACS.
  Future<List<VisitaModel>> listarMinhasPendentes() async {
    final data = await _api.get('/visitas/minhas');

    return (data as List)
        .map((json) => VisitaModel.fromJson(json))
        .where((visita) => visita.status == 'Pendente')
        .toList()
      ..sort((a, b) => a.data.compareTo(b.data));
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