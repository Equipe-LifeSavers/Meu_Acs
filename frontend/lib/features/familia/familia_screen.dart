import 'package:flutter/material.dart';
import 'package:frontend/data/models/familia_model.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../../shared/widgets/app_data_table.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';
import 'familia_controller.dart';
import 'widgets/familia_stat_card.dart';
import 'widgets/familia_form_dialog.dart';
import 'package:data_table_2/data_table_2.dart';

class FamiliaScreen extends StatefulWidget {
  const FamiliaScreen({super.key});

  @override
  State<FamiliaScreen> createState() => _FamiliaScreenState();
}

class _FamiliaScreenState extends State<FamiliaScreen> {
  final controller = FamiliaController();
  final pesquisaController = TextEditingController();

  List<FamiliaModel> familias = [];
  List<FamiliaModel> familiasFiltradas = [];

  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarFamilias();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  Future<void> carregarFamilias() async {
    final lista = await controller.carregarFamilias();

    setState(() {
      familias = lista;
      familiasFiltradas = List.from(lista);
      carregando = false;
    });
  }

  void filtrarFamilias(List<FamiliaModel> lista, String texto) {
    final pesquisa = texto.trim().toLowerCase();

    setState(() {
      if (pesquisa.isEmpty) {
        familiasFiltradas = List.from(lista);
        return;
      }

      familiasFiltradas = lista.where((familia) {
        return familia.responsavel.toLowerCase().contains(pesquisa) ||
            familia.cpfResponsavel.contains(pesquisa) ||
            familia.telefone.contains(pesquisa) ||
            familia.endereco.toLowerCase().contains(pesquisa);
      }).toList();
    });
  }

  Future<void> adicionarFamilia(FamiliaModel familia) async {
    setState(() {
      familias.add(familia);
      filtrarFamilias(familias, pesquisaController.text);
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
                        'Gestão de Famílias',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        'Gerencie todas as famílias cadastradas.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    final novaFamilia = await showDialog<FamiliaModel>(
                      context: context,
                      builder: (_) => const FamiliaFormDialog(),
                    );

                    if (novaFamilia != null) {
                      await adicionarFamilia(novaFamilia);
                    }
                  },
                  icon: const Icon(Icons.add),

                  label: const Text('Nova Família'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: FamiliaStatCard(
                    titulo: 'Famílias',
                    valor: familias.length.toString(),
                    icone: Icons.family_restroom,
                    cor: Colors.blue,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: FamiliaStatCard(
                    titulo: 'Moradores',
                    valor: familias
                        .fold<int>(
                          0,
                          (total, f) => total + f.quantidadeMoradores,
                        )
                        .toString(),
                    icone: Icons.people,
                    cor: Colors.green,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: FamiliaStatCard(
                    titulo: 'Média',
                    valor: familias.isEmpty
                        ? '0'
                        : (familias.fold<int>(
                                    0,
                                    (t, f) => t + f.quantidadeMoradores,
                                  ) /
                                  familias.length)
                              .toStringAsFixed(1),
                    icone: Icons.analytics_outlined,
                    cor: Colors.orange,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextField(
              controller: pesquisaController,
              onChanged: (texto) {
                filtrarFamilias(familias, texto);
              },
              decoration: InputDecoration(
                hintText: 'Pesquisar família...',
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
                  DataColumn2(label: Text('Responsável'), size: ColumnSize.L),
                  DataColumn2(label: Text('CPF'), size: ColumnSize.M),
                  DataColumn2(label: Text('Telefone'), size: ColumnSize.M),
                  DataColumn2(label: Text('Endereço'), size: ColumnSize.L),
                  DataColumn2(label: Text('Moradores'), size: ColumnSize.S),
                  DataColumn2(label: Text('Ações'), fixedWidth: 90),
                ],

                rows: familiasFiltradas.map((familia) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Tooltip(
                          message: familia.responsavel,
                          child: Text(
                            familia.responsavel,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Text(
                          familia.cpfResponsavel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      DataCell(
                        Text(
                          familia.telefone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      DataCell(
                        Tooltip(
                          message: familia.endereco,
                          child: Text(
                            familia.endereco,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(Text(familia.quantidadeMoradores.toString())),

                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.blue,
                              ),
                              onPressed: () {},
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              onPressed: () {},
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
