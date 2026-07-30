import 'package:flutter/material.dart';
import '../../../data/models/residencia_model.dart';
import '../../../data/models/regiao_model.dart';
import '../../../data/services/regiao_service.dart';

class ResidenciaFormDialog extends StatefulWidget {
  final ResidenciaModel? residencia;

  const ResidenciaFormDialog({super.key, this.residencia});

  bool get editando => residencia != null;

  @override
  State<ResidenciaFormDialog> createState() => _ResidenciaFormDialogState();
}

class _ResidenciaFormDialogState extends State<ResidenciaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final enderecoController = TextEditingController();

  final RegiaoService _regiaoService = RegiaoService();
  late Future<List<RegiaoModel>> _futureRegioes;

  String tipoImovel = 'Alvenaria';
  bool possuiAgua = true;
  bool possuiEnergia = true;
  bool possuiEsgoto = true;
  int? regiaoIdSelecionada;

  @override
  void initState() {
    super.initState();

    _futureRegioes = _regiaoService.listarRegioes();

    if (widget.editando) {
      final residencia = widget.residencia!;
      enderecoController.text = residencia.endereco;
      tipoImovel = residencia.tipoImovel.isEmpty ? 'Alvenaria' : residencia.tipoImovel;
      possuiAgua = residencia.possuiAgua;
      possuiEnergia = residencia.possuiEnergia;
      possuiEsgoto = residencia.possuiEsgoto;
      regiaoIdSelecionada = residencia.regiaoId;
    }
  }

  @override
  void dispose() {
    enderecoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editando ? 'Editar Residência' : 'Nova Residência'),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                FutureBuilder<List<RegiaoModel>>(
                  future: _futureRegioes,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Não foi possível carregar as regiões.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      );
                    }

                    final regioes = snapshot.data ?? [];

                    return DropdownButtonFormField<int>(
                      value: regiaoIdSelecionada,
                      decoration: const InputDecoration(labelText: 'Região'),
                      items: regioes
                          .map((r) => DropdownMenuItem(
                                value: r.id,
                                child: Text(r.nomeArea),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          regiaoIdSelecionada = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione uma região';
                        }
                        return null;
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: enderecoController,
                  decoration: const InputDecoration(labelText: 'Endereço'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o endereço';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: tipoImovel,
                  decoration: const InputDecoration(
                    labelText: 'Tipo do imóvel',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Alvenaria',
                      child: Text('Alvenaria'),
                    ),

                    DropdownMenuItem(value: 'Madeira', child: Text('Madeira')),
                    DropdownMenuItem(value: 'Mista', child: Text('Mista')),
                    DropdownMenuItem(value: 'Taipa', child: Text('Taipa')),
                    DropdownMenuItem(value: 'Apartamento', child: Text('Apartamento')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tipoImovel = value!;
                    });
                  },
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  title: const Text('Possui água'),
                  value: possuiAgua,
                  onChanged: (value) {
                    setState(() {
                      possuiAgua = value;
                    });
                  },
                ),

                SwitchListTile(
                  title: const Text('Possui energia'),
                  value: possuiEnergia,
                  onChanged: (value) {
                    setState(() {
                      possuiEnergia = value;
                    });
                  },
                ),

                SwitchListTile(
                  title: const Text('Possui esgoto'),
                  value: possuiEsgoto,
                  onChanged: (value) {
                    setState(() {
                      possuiEsgoto = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),

        ElevatedButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) {
              return;
            }

            final residencia = ResidenciaModel(
              id: widget.editando ? widget.residencia!.id : 0,

              familia: '',
              endereco: enderecoController.text.trim(),
              tipoImovel: tipoImovel,
              possuiAgua: possuiAgua,
              possuiEnergia: possuiEnergia,
              possuiEsgoto: possuiEsgoto,
              regiaoId: regiaoIdSelecionada,
            );

            Navigator.pop(context, residencia);
          },
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}