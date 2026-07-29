import '../../data/models/residencia_model.dart';
import '../../data/repositories/residencia_repository.dart';

class ResidenciaController {
  final ResidenciaRepository _repository = ResidenciaRepository();

  Future<List<ResidenciaModel>> carregarResidencias() async {
    return await _repository.listarResidencias();
  }

  Future<void> adicionarResidencia(ResidenciaModel residencia) async {
    await _repository.adicionarResidencia(residencia);
  }

  Future<void> atualizarResidencia(ResidenciaModel residencia) async {
    await _repository.atualizarResidencia(residencia);
  }

  Future<void> excluirResidencia(int id) async {
    await _repository.excluirResidencia(id);
  }
}
