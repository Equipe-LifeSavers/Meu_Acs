import '../models/regiao_model.dart';
import 'api_service.dart';

class RegiaoService {
  final ApiService _api = ApiService();

  Future<List<RegiaoModel>> listarRegioes() async {
    final data = await _api.get('/regioes');

    return (data as List)
        .map((json) => RegiaoModel.fromJson(json))
        .toList();
  }
}