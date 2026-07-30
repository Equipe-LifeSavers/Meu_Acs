import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/layouts/app_scaffold.dart';
import '../../../data/models/dashboard_model.dart';
import '../../../data/models/visita_model.dart';
import '../../../app/app_routes.dart';
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
  Future<List<VisitaModel>>? _futureVisitasPendentes;

  @override
  void initState() {
    super.initState();
    _futureIndicadores = _controller.buscarIndicadores();

    if (_controller.souAcs) {
      _futureVisitasPendentes = _controller.buscarMinhasVisitasPendentes();
    }
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
              nome: SessionService.instance.usuario?.nome ?? 'Usuário',
            ),

            if (_controller.souAcs) ...[
              const SizedBox(height: 20),

              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go(AppRoutes.visitas),
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Nova Visita'),
                  ),

                  OutlinedButton.icon(
                    onPressed: () => context.go(AppRoutes.moradores),
                    icon: const Icon(Icons.person_add_alt_outlined),
                    label: const Text('Novo Morador'),
                  ),
                ],
              ),
            ],

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
                          childAspectRatio: 1.7,

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

                    if (_controller.souAcs) ...[
                      _MinhasVisitasPendentes(future: _futureVisitasPendentes!),
                      const SizedBox(height: 20),
                    ],

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

class _MinhasVisitasPendentes extends StatelessWidget {
  final Future<List<VisitaModel>> future;

  const _MinhasVisitasPendentes({required this.future});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Minhas Visitas Pendentes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),

              TextButton(
                onPressed: () => context.go(AppRoutes.visitas),
                child: const Text('Ver todas'),
              ),
            ],
          ),

          const SizedBox(height: 8),

          FutureBuilder<List<VisitaModel>>(
            future: future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Não foi possível carregar as visitas pendentes.',
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                );
              }

              final pendentes = snapshot.data ?? [];

              if (pendentes.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text('Nenhuma visita pendente.'),
                );
              }

              final exibidas = pendentes.take(5).toList();

              return Column(
                children: [
                  for (final visita in exibidas)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.schedule, color: Colors.orange),
                      title: Text(visita.familia),
                      subtitle: Text(
                        "${visita.data.day.toString().padLeft(2, '0')}/"
                        "${visita.data.month.toString().padLeft(2, '0')}/"
                        "${visita.data.year} — ${visita.tipoVisita}",
                      ),
                    ),

                  if (pendentes.length > 5)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'e mais ${pendentes.length - 5} visita(s) pendente(s)...',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}