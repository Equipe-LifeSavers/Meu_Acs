import '../models/residencia_model.dart';
import '../services/residencia_service.dart';

class ResidenciaRepository {
  final ResidenciaService _service = ResidenciaService();

  Future<List<ResidenciaModel>> listarResidencias() async {
    return await _service.listarResidencias();
  }

  Future<void> adicionarResidencia(
    ResidenciaModel residencia,
  ) async {
    await _service.adicionarResidencia(residencia);
  }

  Future<void> atualizarResidencia(
    ResidenciaModel residencia,
  ) async {
    await _service.atualizarResidencia(residencia);
  }

  Future<void> excluirResidencia(int id) async {
    await _service.excluirResidencia(id);
  }
}