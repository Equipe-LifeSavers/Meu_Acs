import '../models/morador_model.dart';
import '../services/morador_service.dart';

class MoradorRepository {
  final MoradorService _service = MoradorService();

  Future<List<MoradorModel>> listarMoradores() {
    return _service.listarMoradores();
  }

  Future<void> adicionarMorador(MoradorModel morador) {
    return _service.adicionarMorador(morador);
  }

  Future<void> atualizarMorador(MoradorModel morador) {
    return _service.atualizarMorador(morador);
  }

  Future<void> excluirMorador(int id) {
    return _service.excluirMorador(id);
  }
}
