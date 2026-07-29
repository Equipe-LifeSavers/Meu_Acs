import '../models/residencia_model.dart';
import 'api_service.dart';

class ResidenciaService {
  final ApiService _api = ApiService();

  Future<List<ResidenciaModel>> listarResidencias() async {
    final data = await _api.get('/residencias');

    return (data as List)
        .map((json) => ResidenciaModel.fromJson(json))
        .toList();
  }

  Future<void> adicionarResidencia(ResidenciaModel residencia) async {
    await _api.post('/residencias', residencia.toJson());
  }

  Future<void> atualizarResidencia(ResidenciaModel residencia) async {
    await _api.put('/residencias/${residencia.id}', residencia.toJson());
  }

  Future<void> excluirResidencia(int id) async {
    await _api.delete('/residencias/$id');
  }
}