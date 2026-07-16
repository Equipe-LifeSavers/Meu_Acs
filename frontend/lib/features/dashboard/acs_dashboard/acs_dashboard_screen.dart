import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';
import 'acs_dashboard_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_sidebar.dart';
import '../../../../core/services/session_service.dart';

class AcsDashboardScreen extends StatelessWidget {
  const AcsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AcsDashboardController();
    
    return AppScaffold(
      sidebar: const DashboardSidebar(),

      body: Column(
        children: [
          DashboardHeader(
            saudacao: controller.saudacao,
            nome: SessionService.instance.usuario!.nome,
          ),

          const Expanded(
            child: Center(child: Text('Área principal do Dashboard')),
          ),
        ],
      ),
    );
  }
}
