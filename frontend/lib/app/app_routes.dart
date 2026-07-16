import 'package:go_router/go_router.dart';
import '../features/auth/login/login_screen.dart';
import '../features/dashboard/acs_dashboard/acs_dashboard_screen.dart';

class AppRoutes {
  static const login = '/';
  static const dashboard = '/dashboard';

  static final router = GoRouter(
    initialLocation: login,
    routes: [
      GoRoute(path: login, builder: (context, state) => const LoginScreen()),

      GoRoute(path: dashboard, builder: (context, state) => const AcsDashboardScreen(),
      ),
    ],
  );
}
