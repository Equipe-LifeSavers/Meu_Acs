import '../models/familia_model.dart';
import 'api_service.dart';

class FamiliaService {
  final ApiService _api = ApiService();

  Future<List<FamiliaModel>> listarFamilias() async {
    final data = await _api.get('/familias');

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