import '../models/familia_model.dart';
import '../services/familia_service.dart';

class FamiliaRepository {
  final FamiliaService _service = FamiliaService();

  Future<List<FamiliaModel>> listarFamilias() async {
    return await _service.listarFamilias();
  }

  Future<void> adicionarFamilia(FamiliaModel familia) async {
    await _service.adicionarFamilia(familia);
  }

  Future<void> atualizarFamilia(FamiliaModel familia) async {
    await _service.atualizarFamilia(familia);
  }

  Future<void> excluirFamilia(int id) async {
    await _service.excluirFamilia(id);
  }
}
