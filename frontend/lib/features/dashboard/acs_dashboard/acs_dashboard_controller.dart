import '../../../data/models/dashboard_model.dart';
import '../../../data/services/dashboard_service.dart';

class AcsDashboardController {
  final DashboardService _service = DashboardService();

  String get saudacao {
    final hora = DateTime.now().hour;

    if (hora < 12) {
      return 'Bom dia';

    }else if (hora < 18) {
      return 'Boa tarde';
    }
    return 'Boa noite';
  }

  Future<DashboardModel> buscarIndicadores() {
    return _service.buscarDashboard();
  }
}