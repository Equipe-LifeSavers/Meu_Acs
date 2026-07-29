import 'package:flutter/material.dart';
import '../../../shared/layouts/app_scaffold.dart';
import '../../../data/models/dashboard_model.dart';
import 'acs_dashboard_controller.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_sidebar.dart';
import 'widgets/dashboard_card.dart';
import 'widgets/recent_activity.dart';
import '../../../../core/services/session_service.dart';

class AcsDashboardScreen extends StatefulWidget {
  const AcsDashboardScreen({super.key});

  @override
  State<AcsDashboardScreen> createState() => _AcsDashboardScreenState();
}

class _AcsDashboardScreenState extends State<AcsDashboardScreen> {
  final _controller = AcsDashboardController();
  late Future<DashboardModel> _futureIndicadores;

  @override
  void initState() {
    super.initState();
    _futureIndicadores = _controller.buscarIndicadores();
  }

  @override
  Widget build(BuildContext context) {
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
              saudacao: _controller.saudacao,
              nome: SessionService.instance.usuario!.nome,
            ),

            const SizedBox(height: 30),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<DashboardModel>(
                      future: _futureIndicadores,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 60),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Column(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red, size: 40),
                                  const SizedBox(height: 12),
                                  Text('Não foi possível carregar os indicadores.\n${snapshot.error}',
                                      textAlign: TextAlign.center),
                                ],
                              ),
                            ),
                          );
                        }

                        final dados = snapshot.data!;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),

                          crossAxisCount: quantidadeColunas,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 1.9,

                          children: [
                            DashboardCard(
                              title: 'Famílias',
                              value: dados.totalFamilias.toString(),
                              icon: Icons.groups,
                              iconColor: Colors.blue,
                            ),

                            DashboardCard(
                              title: 'Moradores',
                              value: dados.totalMoradores.toString(),
                              icon: Icons.people,
                              iconColor: Colors.teal,
                            ),

                            DashboardCard(
                              title: 'Residências',
                              value: dados.totalResidencias.toString(),
                              icon: Icons.home_work,
                              iconColor: Colors.orange,
                            ),

                            DashboardCard(
                              title: 'Visitas',
                              value: dados.totalVisitas.toString(),
                              icon: Icons.assignment_turned_in,
                              iconColor: Colors.green,
                            ),
                          ],
                        );
                      },
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
