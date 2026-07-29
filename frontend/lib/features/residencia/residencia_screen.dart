import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../data/models/residencia_model.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../../shared/widgets/app_data_table.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';
import 'residencia_controller.dart';
import 'widgets/residencia_form_dialog.dart';
import 'widgets/residencia_stat_card.dart';

class ResidenciaScreen extends StatefulWidget {
  const ResidenciaScreen({super.key});

  @override
  State<ResidenciaScreen> createState() => _ResidenciaScreenState();
}

class _ResidenciaScreenState extends State<ResidenciaScreen> {
  final controller = ResidenciaController();
  final pesquisaController = TextEditingController();

  List<ResidenciaModel> residencias = [];
  List<ResidenciaModel> residenciasFiltradas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarResidencias();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  Future<void> carregarResidencias() async {
    final lista = await controller.carregarResidencias();

    setState(() {
      residencias = lista;
      residenciasFiltradas = List.from(lista);
      carregando = false;
    });
  }

  void filtrarResidencias(String texto) {
    final pesquisa = texto.trim().toLowerCase();

    setState(() {
      if (pesquisa.isEmpty) {
        residenciasFiltradas = List.from(residencias);
        return;
      }

      residenciasFiltradas = residencias.where((residencia) {
        return residencia.familia.toLowerCase().contains(pesquisa) ||
            residencia.endereco.toLowerCase().contains(pesquisa) ||
            residencia.tipoImovel.toLowerCase().contains(pesquisa);
      }).toList();
    });
  }

  Future<void> adicionarResidencia(ResidenciaModel residencia) async {
    await controller.adicionarResidencia(residencia);
    await carregarResidencias();
    filtrarResidencias(pesquisaController.text);
  }

  Future<void> atualizarResidencia(ResidenciaModel residencia) async {
    await controller.atualizarResidencia(residencia);
    await carregarResidencias();
    filtrarResidencias(pesquisaController.text);
  }

  Future<void> excluirResidencia(int id) async {
    await controller.excluirResidencia(id);
    await carregarResidencias();
    filtrarResidencias(pesquisaController.text);
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
                        'Gestão de Residências',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Gerencie todas as residências cadastradas.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    final novaResidencia = await showDialog<ResidenciaModel>(
                      context: context,
                      builder: (_) => const ResidenciaFormDialog(),
                    );

                    if (novaResidencia != null) {
                      await adicionarResidencia(novaResidencia);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Nova Residência'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ResidenciaStatCard(
                    titulo: 'Residências',
                    valor: residencias.length.toString(),
                    icone: Icons.home,
                    cor: Colors.blue,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ResidenciaStatCard(
                    titulo: 'Com Água',
                    valor: residencias
                        .where((r) => r.possuiAgua)
                        .length
                        .toString(),
                    icone: Icons.water_drop,
                    cor: Colors.blueAccent,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ResidenciaStatCard(
                    titulo: 'Com Energia',
                    valor: residencias
                        .where((r) => r.possuiEnergia)
                        .length
                        .toString(),
                    icone: Icons.electric_bolt,
                    cor: Colors.amber,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextField(
              controller: pesquisaController,
              onChanged: filtrarResidencias,
              decoration: InputDecoration(
                hintText: 'Pesquisar residência...',
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
                  DataColumn2(label: Text('Responsável'), size: ColumnSize.M),
                  DataColumn2(label: Text('Endereço'), size: ColumnSize.L),
                  DataColumn2(label: Text('Tipo'), size: ColumnSize.M),
                  DataColumn2(label: Text('Água'), fixedWidth: 70),
                  DataColumn2(label: Text('Energia'), fixedWidth: 90),
                  DataColumn2(label: Text('Esgoto'), fixedWidth: 80),
                  DataColumn2(label: Text('Ações'), fixedWidth: 90),
                ],

                rows: residenciasFiltradas.map((residencia) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Tooltip(
                          message: residencia.familia,
                          child: Text(
                            residencia.familia,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Tooltip(
                          message: residencia.endereco,
                          child: Text(
                            residencia.endereco,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(Text(residencia.tipoImovel)),

                      DataCell(
                        Center(
                          child: Icon(
                            Icons.water_drop,
                            color: residencia.possuiAgua
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),

                      DataCell(
                        Center(
                          child: Icon(
                            Icons.electric_bolt,
                            color: residencia.possuiEnergia
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),

                      DataCell(
                        Center(
                          child: Icon(
                            Icons.plumbing,
                            color: residencia.possuiEsgoto
                                ? Colors.green
                                : Colors.red,
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
                                final residenciaEditada =
                                    await showDialog<ResidenciaModel>(
                                      context: context,
                                      builder: (_) => ResidenciaFormDialog(
                                        residencia: residencia,
                                      ),
                                    );

                                if (residenciaEditada != null) {
                                  await atualizarResidencia(residenciaEditada);
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
                                    title: const Text('Excluir residência'),

                                    content: Text(
                                      'Deseja realmente excluir a residência de "${residencia.familia}"?',
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
                                  await excluirResidencia(residencia.id);
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
