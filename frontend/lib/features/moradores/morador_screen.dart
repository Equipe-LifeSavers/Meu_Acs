import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../data/models/morador_model.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../../shared/widgets/app_data_table.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';
import 'morador_controller.dart';
import 'widgets/morador_form_dialog.dart';
import 'widgets/morador_stat_card.dart';

class MoradorScreen extends StatefulWidget {
  const MoradorScreen({super.key});

  @override
  State<MoradorScreen> createState() => _MoradorScreenState();
}

class _MoradorScreenState extends State<MoradorScreen> {
  final controller = MoradorController();
  final pesquisaController = TextEditingController();

  List<MoradorModel> moradores = [];
  List<MoradorModel> moradoresFiltrados = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarMoradores();
  }

  @override
  void dispose() {
    pesquisaController.dispose();
    super.dispose();
  }

  Future<void> carregarMoradores() async {
    final lista = await controller.carregarMoradores();

    setState(() {
      moradores = lista;
      moradoresFiltrados = List.from(lista);
      carregando = false;
    });
  }

  void filtrarMoradores(String texto) {
    final pesquisa = texto.trim().toLowerCase();

    setState(() {
      if (pesquisa.isEmpty) {
        moradoresFiltrados = List.from(moradores);
        return;
      }

      moradoresFiltrados = moradores.where((morador) {
        return morador.nome.toLowerCase().contains(pesquisa) ||
            morador.cpf.contains(pesquisa) ||
            morador.telefone.contains(pesquisa) ||
            morador.familia.toLowerCase().contains(pesquisa);
      }).toList();
    });
  }

  Future<void> adicionarMorador(MoradorModel morador) async {
    try {
      await controller.adicionarMorador(morador);
      await carregarMoradores();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Morador cadastrado com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao cadastrar morador: ${_mensagemAmigavel(e)}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> editarMorador(MoradorModel morador) async {
    try {
      await controller.atualizarMorador(morador);
      await carregarMoradores();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Morador atualizado com sucesso.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar morador: ${_mensagemAmigavel(e)}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  Future<void> excluirMorador(int id) async {
    try {
      await controller.excluirMorador(id);
      await carregarMoradores();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir morador: ${_mensagemAmigavel(e)}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _mensagemAmigavel(Object erro) {
    final texto = erro.toString();
    return texto.replaceFirst('Exception: ', '');
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
                        'Gestão de Moradores',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Gerencie todos os moradores cadastrados.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: () async {
                    final novoMorador = await showDialog<MoradorModel>(
                      context: context,
                      builder: (_) => const MoradorFormDialog(),
                    );

                    if (novoMorador != null) {
                      await adicionarMorador(novoMorador);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Morador'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: MoradorStatCard(
                    titulo: 'Moradores',
                    valor: moradores.length.toString(),
                    icone: Icons.people,
                    cor: Colors.blue,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: MoradorStatCard(
                    titulo: 'Masculino',
                    valor: moradores
                        .where((m) => m.sexo == 'Masculino')
                        .length
                        .toString(),
                    icone: Icons.man,
                    cor: Colors.indigo,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: MoradorStatCard(
                    titulo: 'Feminino',
                    valor: moradores
                        .where((m) => m.sexo == 'Feminino')
                        .length
                        .toString(),
                    icone: Icons.woman,
                    cor: Colors.pink,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            TextField(
              controller: pesquisaController,
              onChanged: filtrarMoradores,
              decoration: InputDecoration(
                hintText: 'Pesquisar morador...',
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
                  DataColumn2(label: Text('Nome'), size: ColumnSize.L),
                  DataColumn2(label: Text('CPF'), size: ColumnSize.M),
                  DataColumn2(label: Text('Telefone'), size: ColumnSize.M),
                  DataColumn2(label: Text('Idade'), size: ColumnSize.S),
                  DataColumn2(label: Text('Sexo'), size: ColumnSize.S),
                  DataColumn2(label: Text('Família'), size: ColumnSize.L),
                  DataColumn2(label: Text('Ações'), fixedWidth: 90),
                ],
                rows: moradoresFiltrados.map((morador) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Tooltip(
                          message: morador.nome,
                          child: Text(
                            morador.nome,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Tooltip(
                          message: morador.cpf,
                          child: Text(
                            morador.cpf,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(
                        Tooltip(
                          message: morador.telefone.isEmpty
                              ? '-'
                              : morador.telefone,
                          child: Text(
                            morador.telefone.isEmpty ? '-' : morador.telefone,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                      DataCell(Text(morador.idade.toString())),

                      DataCell(Text(morador.sexo)),

                      DataCell(
                        Tooltip(
                          message: morador.familia,
                          child: Text(
                            morador.familia,
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
                              tooltip: 'Editar',
                              onPressed: () async {
                                final moradorEditado =
                                    await showDialog<MoradorModel>(
                                      context: context,
                                      builder: (_) =>
                                          MoradorFormDialog(morador: morador),
                                    );

                                if (moradorEditado != null) {
                                  await editarMorador(moradorEditado);
                                }
                              },
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                              tooltip: 'Excluir',
                              onPressed: () async {
                                final confirmar = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Excluir morador'),
                                    content: Text(
                                      'Deseja realmente excluir "${morador.nome}"?',
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
                                  await excluirMorador(morador.id);
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
