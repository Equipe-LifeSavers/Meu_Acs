import '../models/acs_model.dart';
import 'api_service.dart';

class AcsService {
  final ApiService _api = ApiService();

  Future<List<AcsModel>> listarAcs() async {
    final data = await _api.get('/acs');

    return (data as List)
        .map((json) => AcsModel.fromJson(json))
        .toList();
  }
}