import 'package:flutter/material.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';

class ResidenciaScreen extends StatelessWidget {
  const ResidenciaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      sidebar: DashboardSidebar(),
      body: Center(
        child: Text(
          'Tela de Residências\n\nEm desenvolvimento...',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}