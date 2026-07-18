import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';
import 'acs_dashboard_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_sidebar.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/recent_activity.dart';
import '../../../../core/services/session_service.dart';

class AcsDashboardScreen extends StatelessWidget {
  const AcsDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AcsDashboardController();
    final larguraTela = MediaQuery.of(context).size.width;

    int quantidadeColunas;

    if (larguraTela >= 1600) {
      quantidadeColunas = 4;
    } else if (larguraTela >= 1200) {
      quantidadeColunas = 3;
    } else if (larguraTela >= 800) {
      quantidadeColunas = 2;
    } else {
      quantidadeColunas = 1;
    }

    return AppScaffold(
      sidebar: const DashboardSidebar(),

      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(
              saudacao: controller.saudacao,
              nome: SessionService.instance.usuario!.nome,
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),

                      crossAxisCount: quantidadeColunas,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.9,

                      children: const [
                        DashboardCard(
                          title: 'Famílias',
                          value: '248',
                          icon: Icons.groups,
                          iconColor: Colors.blue,
                        ),

                        DashboardCard(
                          title: 'Moradores',
                          value: '1.023',
                          icon: Icons.people,
                          iconColor: Colors.teal,
                        ),

                        DashboardCard(
                          title: 'Residências',
                          value: '251',
                          icon: Icons.home_work,
                          iconColor: Colors.orange,
                        ),

                        DashboardCard(
                          title: 'Visitas',
                          value: '34',
                          icon: Icons.assignment_turned_in,
                          iconColor: Colors.green,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    const RecentActivity(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
