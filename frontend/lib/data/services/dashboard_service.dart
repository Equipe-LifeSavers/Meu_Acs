import '../models/dashboard_model.dart';
import 'api_service.dart';
import '../../core/services/session_service.dart';

class DashboardService {
  final ApiService _api = ApiService();

  Future<DashboardModel> buscarDashboard() async {
    final endpoint = SessionService.instance.perfil == 'ACS'
        ? '/dashboard/minha-regiao'
        : '/dashboard';

    final data = await _api.get(endpoint);
    return DashboardModel.fromJson(data);
  }
}