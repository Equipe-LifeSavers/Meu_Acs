import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/visita_model.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../../shared/widgets/app_data_table.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';
import 'visita_controller.dart';
import 'widgets/visita_form_dialog.dart';
import 'widgets/visita_stat_card.dart';

class VisitaScreen extends StatefulWidget {
  const VisitaScreen({super.key});

  @override
  State<VisitaScreen> createState() => _VisitaScreenState();
}

class _VisitaScreenState extends State<VisitaScreen> {
  final controller = VisitaController();
  final pesquisaController = TextEditingController();

  List<VisitaModel> visitas = [];
  List<VisitaModel> visitasFiltradas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarVisitas();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  Future<void> carregarVisitas() async {
    final lista = await controller.carregarVisitas();

    setState(() {
      visitas = lista;
      visitasFiltradas = List.from(lista);
      carregando = false;
    });
  }

  void filtrarVisitas(String texto) {
    final pesquisa = texto.trim().toLowerCase();

    setState(() {
      if (pesquisa.isEmpty) {
        visitasFiltradas = List.from(visitas);
        return;
      }

      visitasFiltradas = visitas.where((visita) {
        return visita.familia.toLowerCase().contains(pesquisa) ||
            visita.agente.toLowerCase().contains(pesquisa) ||
            visita.tipoVisita.toLowerCase().contains(pesquisa) ||
            visita.status.toLowerCase().contains(pesquisa) ||
            visita.observacao.toLowerCase().contains(pesquisa);
      }).toList();
    });
  }

  Future<void> adicionarVisita(VisitaModel visita) async {
    try {
      await controller.adicionarVisita(visita);
      await carregarVisitas();
      filtrarVisitas(pesquisaController.text);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visita cadastrada com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar visita: ${_mensagemAmigavel(e)}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> atualizarVisita(VisitaModel visita) async {
    try {
      await controller.atualizarVisita(visita);
      await carregarVisitas();
      filtrarVisitas(pesquisaController.text);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Visita atualizada com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar visita: ${_mensagemAmigavel(e)}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> excluirVisita(int id) async {
    try {
      await controller.excluirVisita(id);
      await carregarVisitas();
      filtrarVisitas(pesquisaController.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir visita: ${_mensagemAmigavel(e)}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _mensagemAmigavel(Object erro) {
    return erro.toString().replaceFirst('Exception: ', '');
  }

  Color corStatus(String status) {
    switch (status) {
      case 'Realizada':
        return Colors.green;

      case 'Pendente':
        return Colors.orange;

      default:
        return Colors.grey;
    }
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
                        'Gestão de Visitas',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Gerencie todas as visitas cadastradas.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Nova Visita'),
                  onPressed: () async {
                    final novaVisita = await showDialog<VisitaModel>(
                      context: context,
                      builder: (_) => const VisitaFormDialog(),
                    );

                    if (novaVisita != null) {
                      await adicionarVisita(novaVisita);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: VisitaStatCard(
                    titulo: 'Total',
                    valor: visitas.length.toString(),
                    icone: Icons.assignment,
                    cor: Colors.blue,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: VisitaStatCard(
                    titulo: 'Realizadas',
                    valor: visitas
                        .where((v) => v.status == 'Realizada')
                        .length
                        .toString(),
                    icone: Icons.check_circle,
                    cor: Colors.green,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: VisitaStatCard(
                    titulo: 'Pendentes',
                    valor: visitas
                        .where((v) => v.status == 'Pendente')
                        .length
                        .toString(),
                    icone: Icons.schedule,
                    cor: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextField(
              controller: pesquisaController,
              onChanged: filtrarVisitas,
              decoration: InputDecoration(
                hintText: 'Pesquisar visita...',
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
                  DataColumn2(label: Text('Família'), size: ColumnSize.L),
                  DataColumn2(label: Text('Agente'), size: ColumnSize.M),
                  DataColumn2(label: Text('Data'), size: ColumnSize.S),
                  DataColumn2(label: Text('Tipo'), size: ColumnSize.S),
                  DataColumn2(label: Text('Status'), size: ColumnSize.S),
                  DataColumn2(label: Text('Observação'), size: ColumnSize.L),
                  DataColumn2(label: Text('Ações'), fixedWidth: 90),
                ],

                rows: visitasFiltradas.map((visita) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Tooltip(
                          message: visita.familia,
                          child: Text(
                            visita.familia,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Tooltip(
                          message: visita.agente,
                          child: Text(
                            visita.agente,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Text(DateFormat('dd/MM/yyyy').format(visita.data)),
                      ),

                      DataCell(Text(visita.tipoVisita)),

                      DataCell(
                        Center(
                          child: Chip(
                            visualDensity: VisualDensity.compact,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 0,
                            ),
                            label: Text(
                              visita.status,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: corStatus(visita.status),
                          ),
                        ),
                      ),

                      DataCell(
                        Tooltip(
                          message: visita.observacao,
                          child: Text(
                            visita.observacao,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.blue,
                              ),
                              onPressed: () async {
                                final visitaEditada =
                                    await showDialog<VisitaModel>(
                                      context: context,
                                      builder: (_) =>
                                          VisitaFormDialog(visita: visita),
                                    );

                                if (visitaEditada != null) {
                                  await atualizarVisita(visitaEditada);
                                }
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () async {
                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Excluir visita'),

                                    content: Text(
                                      'Deseja realmente excluir a visita da família "${visita.familia}"?',
                                    ),

                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('Cancelar'),
                                      ),

                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmar == true) {
                                  await excluirVisita(visita.id);
                                }
                              },
                            ),
                          ],
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