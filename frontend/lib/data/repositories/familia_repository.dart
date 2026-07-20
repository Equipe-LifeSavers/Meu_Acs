import '../models/familia_model.dart';
import '../services/familia_service.dart';

class FamiliaRepository {
  final FamiliaService _service = FamiliaService();

  Future<List<FamiliaModel>> listarFamilias() {
    return _service.listarFamilias();
  }
}
