import 'package:flutter/material.dart';
import '../../../data/models/familia_model.dart';
import '../../../data/models/residencia_model.dart';
import '../../../data/models/morador_model.dart';
import '../../../data/services/residencia_service.dart';
import '../../../data/services/morador_service.dart';

class FamiliaFormDialog extends StatefulWidget {
  final FamiliaModel? familia;
  const FamiliaFormDialog({super.key, this.familia});
  bool get editando => familia != null;

  @override
  State<FamiliaFormDialog> createState() => _FamiliaFormDialogState();
}

class _FamiliaFormDialogState extends State<FamiliaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final ResidenciaService _residenciaService = ResidenciaService();
  final MoradorService _moradorService = MoradorService();

  late Future<List<ResidenciaModel>> _futureResidencias;
  late Future<List<MoradorModel>> _futureMoradores;

  int? residenciaIdSelecionada;
  int? responsavelIdSelecionado;

  @override
  void initState() {
    super.initState();

    _futureResidencias = _residenciaService.listarResidencias();
    _futureMoradores = _moradorService.listarMoradores();

    if (widget.editando) {
      residenciaIdSelecionada = widget.familia!.residenciaId;
      responsavelIdSelecionado = widget.familia!.responsavelId;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editando ? 'Editar Família' : 'Nova Família'),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ---------- Residência ----------
                FutureBuilder<List<ResidenciaModel>>(
                  future: _futureResidencias,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Não foi possível carregar as residências.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      );
                    }

                    final residencias = snapshot.data ?? [];

                    return DropdownButtonFormField<int>(
                      value: residenciaIdSelecionada,
                      decoration: const InputDecoration(labelText: 'Residência'),
                      isExpanded: true,
                      items: residencias
                          .map((r) => DropdownMenuItem(
                                value: r.id,
                                child: Text(
                                  r.endereco,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          residenciaIdSelecionada = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione uma residência';
                        }
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // ---------- Responsável ----------
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
                      value: responsavelIdSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Responsável (morador)',
                      ),
                      isExpanded: true,
                      items: moradores
                          .map((m) => DropdownMenuItem(
                                value: m.id,
                                child: Text(
                                  '${m.nome} — ${m.cpf}',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          responsavelIdSelecionado = value;
                        });
                      },
                      // Sem validator: o backend permite família sem
                      // responsável definido ainda (responsavel_id nullable).
                    );
                  },
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

            final familia = FamiliaModel(
              id: widget.familia?.id ?? 0,
              responsavel: '',
              cpfResponsavel: '',
              telefone: '',
              endereco: '',
              quantidadeMoradores: widget.familia?.quantidadeMoradores ?? 0,
              residenciaId: residenciaIdSelecionada,
              responsavelId: responsavelIdSelecionado,
            );

            Navigator.pop(context, familia);
          },
          child: Text(widget.editando ? 'Salvar Alterações' : 'Salvar'),
        ),
      ],
    );
  }
}
