import '../models/visita_model.dart';
import '../services/visita_service.dart';

class VisitaRepository {
  final VisitaService _service = VisitaService();

  Future<List<VisitaModel>> listarVisitas() async {
    return await _service.listarVisitas();
  }

  Future<void> adicionarVisita(VisitaModel visita) async {
    await _service.adicionarVisita(visita);
  }

  Future<void> atualizarVisita(VisitaModel visita) async {
    await _service.atualizarVisita(visita);
  }

  Future<void> excluirVisita(int id) async {
    await _service.excluirVisita(id);
  }
}
