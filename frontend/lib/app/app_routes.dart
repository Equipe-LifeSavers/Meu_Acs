import 'package:go_router/go_router.dart';
import '../features/auth/login/login_screen.dart';
import '../features/dashboard/acs_dashboard/acs_dashboard_screen.dart';
import '../features/familia/familia_screen.dart';
import '../features/morador/morador_screen.dart';
import '../features/residencia/residencia_screen.dart';
import '../features/visita/visita_screen.dart';
import '../features/relatorio/relatorio_screen.dart';
import '../features/configuracoes/configuracoes_screen.dart';

class AppRoutes {
  static const login = '/';

  static const dashboard = '/dashboard';

  static const familias = '/familias';

  static const moradores = '/moradores';

  static const residencias = '/residencias';

  static const visitas = '/visitas';

  static const relatorios = '/relatorios';

  static const configuracoes = '/configuracoes';

  static final router = GoRouter(
    initialLocation: login,

    routes: [
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),

      GoRoute(path: dashboard, builder: (context, state) => const AcsDashboardScreen(),),

      GoRoute(path: familias, builder: (context, state) => const FamiliaScreen(),),

      GoRoute(path: moradores, builder: (context, state) => const MoradorScreen(),),

      GoRoute(path: residencias, builder: (context, state) => const ResidenciaScreen(),),

      GoRoute(path: visitas, builder: (context, state) => const VisitaScreen()),

      GoRoute(path: relatorios, builder: (context, state) => const RelatorioScreen(),),

      GoRoute(path: configuracoes, builder: (context, state) => const ConfiguracoesScreen(),),
    ],
  );
}
