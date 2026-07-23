import '../../data/models/familia_model.dart';
import '../../data/repositories/familia_repository.dart';

class FamiliaController {
  final FamiliaRepository _repository = FamiliaRepository();

  Future<List<FamiliaModel>> carregarFamilias() async {
    return await _repository.listarFamilias();
  }
}
