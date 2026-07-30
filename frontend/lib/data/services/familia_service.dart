import '../models/familia_model.dart';
import 'api_service.dart';
import '../../core/services/session_service.dart';

class FamiliaService {
  final ApiService _api = ApiService();

  Future<List<FamiliaModel>> listarFamilias() async {
    // ACS só vê as famílias da própria região (endpoint escopado no
    // backend); ADMIN/UBS veem todas.
    final endpoint = SessionService.instance.perfil == 'ACS'
        ? '/familias/minhas'
        : '/familias';

    final data = await _api.get(endpoint);

    return (data as List)
        .map((json) => FamiliaModel.fromJson(json))
        .toList();
  }

  Future<void> adicionarFamilia(FamiliaModel familia) async {
    await _api.post('/familias', familia.toJson());
  }

  Future<void> atualizarFamilia(FamiliaModel familiaAtualizada) async {
    await _api.put('/familias/${familiaAtualizada.id}', familiaAtualizada.toJson());
  }

  Future<void> excluirFamilia(int id) async {
    await _api.delete('/familias/$id');
  }
}