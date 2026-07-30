import '../../../data/models/dashboard_model.dart';
import '../../../data/models/visita_model.dart';
import '../../../data/services/dashboard_service.dart';
import '../../../data/services/visita_service.dart';
import '../../../core/services/session_service.dart';

class AcsDashboardController {
  final DashboardService _service = DashboardService();
  final VisitaService _visitaService = VisitaService();

  bool get souAcs => SessionService.instance.perfil == 'ACS';

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

  Future<List<VisitaModel>> buscarMinhasVisitasPendentes() {
    return _visitaService.listarMinhasPendentes();
  }
}