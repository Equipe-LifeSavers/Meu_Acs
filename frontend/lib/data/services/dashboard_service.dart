import '../models/dashboard_model.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService _api = ApiService();

  Future<DashboardModel> buscarDashboard() async {
    final data = await _api.get('/dashboard');
    return DashboardModel.fromJson(data);
  }
}