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
}