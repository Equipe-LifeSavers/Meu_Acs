import '../mocks/visita_mock.dart';
import '../models/visita_model.dart';

class VisitaService {
  // Na integração substituir este método por GET /visitas
  Future<List<VisitaModel>> listarVisitas() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.from(VisitaMock.visitas);
  }

  // Na integração substituir por POST /visitas
  Future<void> adicionarVisita(VisitaModel visita) async {
    await Future.delayed(const Duration(milliseconds: 300));

    VisitaMock.visitas.add(visita);
  }

  // Na integração substituir por PUT /visitas/{id}
  Future<void> atualizarVisita(VisitaModel visitaAtualizada) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = VisitaMock.visitas.indexWhere(
      (v) => v.id == visitaAtualizada.id,
    );

    if (index != -1) {
      VisitaMock.visitas[index] = visitaAtualizada;
    }
  }

  // Na integração substituir por DELETE /visitas/{id}
  Future<void> excluirVisita(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    VisitaMock.visitas.removeWhere((v) => v.id == id);
  }
}
