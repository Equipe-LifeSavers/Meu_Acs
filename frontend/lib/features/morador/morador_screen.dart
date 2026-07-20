import 'package:flutter/material.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';

class MoradorScreen extends StatelessWidget {
  const MoradorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      sidebar: DashboardSidebar(),
      body: Center(
        child: Text(
          'Tela de Moradores\n\nEm desenvolvimento...',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
