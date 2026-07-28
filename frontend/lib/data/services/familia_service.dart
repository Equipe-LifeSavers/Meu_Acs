import '../mocks/familia_mock.dart';
import '../models/familia_model.dart';

class FamiliaService {
  Future<List<FamiliaModel>> listarFamilias() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return List.from(FamiliaMock.familias);
  }

  Future<void> adicionarFamilia(FamiliaModel familia) async {
    await Future.delayed(const Duration(milliseconds: 300));

    FamiliaMock.familias.add(familia);
  }

  Future<void> atualizarFamilia(FamiliaModel familiaAtualizada) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = FamiliaMock.familias.indexWhere(
      (f) => f.id == familiaAtualizada.id,
    );

    if (index != -1) {
      FamiliaMock.familias[index] = familiaAtualizada;
    }
  }

  Future<void> excluirFamilia(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    FamiliaMock.familias.removeWhere((familia) => familia.id == id);
  }
}
