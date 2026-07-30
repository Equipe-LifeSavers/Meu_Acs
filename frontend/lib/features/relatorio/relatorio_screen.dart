import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../../shared/widgets/app_data_table.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';
import '../../data/models/relatorio_model.dart';
import 'relatorio_controller.dart';
import 'widgets/relatorio_stat_card.dart';
import 'widgets/relatorio_detail_dialog.dart';
import '../../shared/widgets/table_action_buttons.dart';

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  final controller = RelatorioController();
  final pesquisaController = TextEditingController();

  List<RelatorioModel> relatorios = [];
  List<RelatorioModel> relatoriosFiltrados = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarRelatorios();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  Future<void> carregarRelatorios() async {
    final lista = await controller.carregarRelatorios();

    setState(() {
      relatorios = lista;
      relatoriosFiltrados = List.from(lista);
      carregando = false;
    });
  }

  void filtrarRelatorios(String texto) {
    final pesquisa = texto.trim().toLowerCase();

    setState(() {
      if (pesquisa.isEmpty) {
        relatoriosFiltrados = List.from(relatorios);
        return;
      }

      relatoriosFiltrados = relatorios.where((relatorio) {
        return relatorio.regiao.toLowerCase().contains(pesquisa) ||
            relatorio.ubs.toLowerCase().contains(pesquisa);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return AppScaffold(
        sidebar: const DashboardSidebar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return AppScaffold(
      sidebar: const DashboardSidebar(),

      body: Padding(
        padding: const EdgeInsets.all(32),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Relatórios',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Consulte os indicadores das regiões e gere relatórios em PDF.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      await controller.gerarRelatorioGeral();

                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Relatório geral gerado com sucesso.'),
                        ),
                      );
                    } catch (e) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao gerar relatório: $e'),
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      );
                    }
                  },

                  icon: const Icon(Icons.picture_as_pdf),

                  label: const Text('Gerar Relatório Geral'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: RelatorioStatCard(
                    titulo: 'Regiões',
                    valor: controller.totalRegioes(relatorios).toString(),
                    icone: Icons.map,
                    cor: Colors.blue,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: RelatorioStatCard(
                    titulo: 'ACS',
                    valor: controller.totalAcs(relatorios).toString(),
                    icone: Icons.badge,
                    cor: Colors.green,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: RelatorioStatCard(
                    titulo: 'Famílias',
                    valor: controller.totalFamilias(relatorios).toString(),
                    icone: Icons.family_restroom,
                    cor: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextField(
              controller: pesquisaController,
              onChanged: filtrarRelatorios,
              decoration: InputDecoration(
                hintText: 'Pesquisar por região ou UBS...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: AppDataTable(
                columns: const [
                  DataColumn2(label: Text('Região'), size: ColumnSize.L),
                  DataColumn2(label: Text('UBS'), size: ColumnSize.L),
                  DataColumn2(label: Text('ACS'), size: ColumnSize.S),
                  DataColumn2(label: Text('Famílias'), size: ColumnSize.S),
                  DataColumn2(label: Text('Moradores'), size: ColumnSize.S),
                  DataColumn2(label: Text('Visitas'), size: ColumnSize.S),
                  DataColumn2(label: Text('Ações'), fixedWidth: 110),
                ],

                rows: relatoriosFiltrados.map((relatorio) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Tooltip(
                          message: relatorio.regiao,
                          child: Text(
                            relatorio.regiao,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Tooltip(
                          message: relatorio.ubs,
                          child: Text(
                            relatorio.ubs,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(Text(relatorio.totalAcs.toString())),
                      DataCell(Text(relatorio.totalFamilias.toString())),
                      DataCell(Text(relatorio.totalMoradores.toString())),
                      DataCell(Text(relatorio.totalVisitas.toString())),
                      DataCell(
                        TableActionButtons(
                          onView: () {
                            showDialog(
                              context: context,
                              builder: (_) =>
                                  RelatorioDetailDialog(relatorio: relatorio),
                            );
                          },
                          onPdf: () async {
                            try {
                              await controller.gerarRelatorioPorRegiao(
                                relatorio.id,
                              );
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'PDF da região "${relatorio.regiao}" gerado com sucesso.',
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Erro ao gerar PDF: $e'),
                                  backgroundColor: Theme.of(context).colorScheme.error,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
