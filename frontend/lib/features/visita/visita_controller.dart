import '../../data/models/visita_model.dart';
import '../../data/repositories/visita_repository.dart';

class VisitaController {
  final VisitaRepository _repository = VisitaRepository();

  Future<List<VisitaModel>> carregarVisitas() async {
    return await _repository.listarVisitas();
  }

  Future<void> adicionarVisita(VisitaModel visita) async {
    await _repository.adicionarVisita(visita);
  }

  Future<void> atualizarVisita(VisitaModel visita) async {
    await _repository.atualizarVisita(visita);
  }

  Future<void> excluirVisita(int id) async {
    await _repository.excluirVisita(id);
  }
}
