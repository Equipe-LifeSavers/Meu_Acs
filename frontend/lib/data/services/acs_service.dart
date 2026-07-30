import '../models/acs_model.dart';
import 'api_service.dart';

class AcsService {
  final ApiService _api = ApiService();

  Future<List<AcsModel>> listarAcs() async {
    final data = await _api.get('/acs');

    return (data as List)
        .map((json) => AcsModel.fromJson(json))
        .toList();
  }

  /// Só funciona pra quem está logado como ACS -- devolve o próprio
  /// registro (id, nome) do agente autenticado.
  Future<AcsModel?> buscarMeuAcs() async {
    try {
      final data = await _api.get('/acs/me');
      return AcsModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}