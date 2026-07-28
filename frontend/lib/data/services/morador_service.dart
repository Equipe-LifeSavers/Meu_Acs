import '../mocks/morador_mock.dart';
import '../models/morador_model.dart';

class MoradorService {
  Future<List<MoradorModel>> listarMoradores() async {
    await Future.delayed(const Duration(milliseconds: 500));

    //  Substituir pelo GET /moradores

    return List.from(MoradorMock.moradores);
  }

  Future<void> adicionarMorador(MoradorModel morador) async {
    await Future.delayed(const Duration(milliseconds: 300));

    //  Substituir pelo POST /moradores

    MoradorMock.moradores.add(morador);
  }

  Future<void> atualizarMorador(MoradorModel morador) async {
    await Future.delayed(const Duration(milliseconds: 300));

    //  Substituir pelo PUT /moradores/{id}

    final index = MoradorMock.moradores.indexWhere((m) => m.id == morador.id);

    if (index != -1) {
      MoradorMock.moradores[index] = morador;
    }
  }

  Future<void> excluirMorador(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    //  Substituir pelo DELETE /moradores/{id}

    MoradorMock.moradores.removeWhere((m) => m.id == id);
  }
}
