import '../../data/models/morador_model.dart';
import '../../data/repositories/morador_repository.dart';

class MoradorController {
  final MoradorRepository _repository = MoradorRepository();

  Future<List<MoradorModel>> carregarMoradores() async {
    return await _repository.listarMoradores();
  }

  Future<void> adicionarMorador(MoradorModel morador) async {
    await _repository.adicionarMorador(morador);
  }

  Future<void> atualizarMorador(MoradorModel morador) async {
    await _repository.atualizarMorador(morador);
  }

  Future<void> excluirMorador(int id) async {
    await _repository.excluirMorador(id);
  }
}
