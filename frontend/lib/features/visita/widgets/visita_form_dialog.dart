import 'package:flutter/material.dart';
import '../../../data/models/visita_model.dart';
import '../../../data/models/morador_model.dart';
import '../../../data/models/acs_model.dart';
import '../../../data/services/morador_service.dart';
import '../../../data/services/acs_service.dart';
import '../../../core/services/session_service.dart';

class VisitaFormDialog extends StatefulWidget {
  final VisitaModel? visita;
  const VisitaFormDialog({super.key, this.visita});
  bool get editando => visita != null;

  @override
  State<VisitaFormDialog> createState() => _VisitaFormDialogState();
}

// Precisa bater com o enum Demanda do backend (com.clinica.agendamento.enums.Demanda).
const Map<String, String> _demandas = {
  'HIPERTENSAO': 'Hipertensão',
  'DIABETES': 'Diabetes',
  'GESTANTE': 'Gestante',
  'VACINACAO': 'Vacinação',
  'DENGUE': 'Dengue',
  'SAUDE_MENTAL': 'Saúde mental',
  'IDOSO': 'Idoso',
  'CRIANCA': 'Criança',
  'OUTROS': 'Outros',
};

class _VisitaFormDialogState extends State<VisitaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final observacaoController = TextEditingController();

  final MoradorService _moradorService = MoradorService();
  final AcsService _acsService = AcsService();

  late Future<List<MoradorModel>> _futureMoradores;
  late Future<List<AcsModel>> _futureAcs;

  int? moradorIdSelecionado;
  int? acsIdSelecionado;
  DateTime? data;
  String demanda = 'OUTROS';
  bool visitaRealizada = false;

  final bool souAcs = SessionService.instance.perfil == 'ACS';
  String? meuNomeAcs;

  @override
  void initState() {
    super.initState();

    _futureMoradores = _moradorService.listarMoradores();
    _futureAcs = _acsService.listarAcs();

    if (widget.editando) {
      final visita = widget.visita!;
      moradorIdSelecionado = visita.moradorId;
      acsIdSelecionado = visita.acsId;
      observacaoController.text = visita.observacao;
      data = visita.data;
      demanda = _demandas.containsKey(visita.tipoVisita)
          ? visita.tipoVisita
          : 'OUTROS';
      visitaRealizada = visita.status == 'Realizada';
    } else {
      data = DateTime.now();
    }

    // Um ACS só pode registrar visita em nome de si mesmo -- busca o
    // próprio registro e trava o campo (a não ser que já esteja editando
    // uma visita existente de outro agente, aí deixa como está).
    if (souAcs && !widget.editando) {
      _acsService.buscarMeuAcs().then((meuAcs) {
        if (meuAcs != null && mounted) {
          setState(() {
            acsIdSelecionado = meuAcs.id;
            meuNomeAcs = meuAcs.nome;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    observacaoController.dispose();
    super.dispose();
  }

  Future<void> selecionarData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: data!,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
    );

    if (escolhida != null) {
      setState(() {
        data = escolhida;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editando ? 'Editar Visita' : 'Nova Visita'),

      content: SizedBox(
        width: 500,

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------- Morador ----------
                FutureBuilder<List<MoradorModel>>(
                  future: _futureMoradores,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Não foi possível carregar os moradores.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      );
                    }

                    final moradores = snapshot.data ?? [];

                    return DropdownButtonFormField<int>(
                      value: moradorIdSelecionado,
                      decoration: const InputDecoration(labelText: 'Morador visitado'),
                      isExpanded: true,
                      items: moradores
                          .map((m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(m.nome, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          moradorIdSelecionado = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return 'Selecione o morador';
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // ---------- ACS ----------
                if (souAcs)
                  TextFormField(
                    initialValue: meuNomeAcs ?? 'Carregando...',
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Agente (ACS)',
                      helperText: 'Visitas são sempre registradas em seu próprio nome.',
                    ),
                  )
                else
                  FutureBuilder<List<AcsModel>>(
                  future: _futureAcs,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Não foi possível carregar os ACS.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      );
                    }

                    final agentes = snapshot.data ?? [];

                    return DropdownButtonFormField<int>(
                      value: acsIdSelecionado,
                      decoration: const InputDecoration(labelText: 'Agente (ACS)'),
                      isExpanded: true,
                      items: agentes
                          .map((a) => DropdownMenuItem(
                                value: a.id,
                                child: Text(a.nome, overflow: TextOverflow.ellipsis),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          acsIdSelecionado = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) return 'Selecione o agente';
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Data da visita'),
                  subtitle: Text(
                    "${data!.day.toString().padLeft(2, '0')}/"
                    "${data!.month.toString().padLeft(2, '0')}/"
                    "${data!.year}",
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: selecionarData,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: demanda,
                  decoration: const InputDecoration(
                    labelText: 'Demanda',
                  ),
                  items: _demandas.entries
                      .map((e) => DropdownMenuItem(
                            value: e.key,
                            child: Text(e.value),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      demanda = value!;
                    });
                  },
                ),

                const SizedBox(height: 8),

                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Visita realizada'),
                  value: visitaRealizada,
                  onChanged: (value) {
                    setState(() {
                      visitaRealizada = value;
                    });
                  },
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: observacaoController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Observações'),
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),

        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            Navigator.pop(
              context,
              VisitaModel(
                id: widget.visita?.id ?? 0,
                familia: '',
                agente: '',
                data: data!,
                tipoVisita: demanda,
                observacao: observacaoController.text.trim(),
                status: visitaRealizada ? 'Realizada' : 'Pendente',
                moradorId: moradorIdSelecionado,
                acsId: acsIdSelecionado,
              ),
            );
          },
          child: Text(widget.editando ? 'Salvar Alterações' : 'Salvar'),
        ),
      ],
    );
  }
}