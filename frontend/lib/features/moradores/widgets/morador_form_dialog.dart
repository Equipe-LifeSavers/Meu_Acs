import 'package:flutter/material.dart';
import '../../../data/models/morador_model.dart';
import '../../../data/models/familia_model.dart';
import '../../../data/services/familia_service.dart';

class MoradorFormDialog extends StatefulWidget {
  final MoradorModel? morador;
  const MoradorFormDialog({super.key, this.morador});

  @override
  State<MoradorFormDialog> createState() => _MoradorFormDialogState();
}

// Precisa bater com o enum Sexo do backend (com.clinica.agendamento.enums.Sexo).
const Map<String, String> _sexos = {
  'MASCULINO': 'Masculino',
  'FEMININO': 'Feminino',
  'OUTRO': 'Outro',
};

class _MoradorFormDialogState extends State<MoradorFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();

  final FamiliaService _familiaService = FamiliaService();
  late Future<List<FamiliaModel>> _futureFamilias;

  DateTime? dataNascimento;
  String? sexo;
  int? familiaIdSelecionada;

  @override
  void initState() {
    super.initState();

    _futureFamilias = _familiaService.listarFamilias();

    if (widget.morador != null) {
      final morador = widget.morador!;

      nomeController.text = morador.nome;
      cpfController.text = morador.cpf;
      telefoneController.text = morador.telefone;

      dataNascimento = morador.dataNascimento;

      // O model guarda o sexo como veio do backend (ex: "MASCULINO").
      sexo = _sexos.containsKey(morador.sexo) ? morador.sexo : null;

      familiaIdSelecionada = int.tryParse(morador.familia);
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
    super.dispose();
  }

  Future<void> selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: dataNascimento ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (data != null) {
      setState(() {
        dataNascimento = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.morador == null ? 'Novo Morador' : 'Editar Morador'),
      content: SizedBox(
        width: 450,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nomeController,
                  decoration: const InputDecoration(labelText: 'Nome'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o nome';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    hintText: 'Somente números, 11 dígitos',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    final apenasDigitos = (value ?? '').replaceAll(RegExp(r'\D'), '');

                    if (apenasDigitos.isEmpty) {
                      return 'Informe o CPF';
                    }

                    if (apenasDigitos.length != 11) {
                      return 'CPF deve ter 11 dígitos (sem pontos ou traço)';
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: telefoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                ),

                const SizedBox(height: 16),

                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    dataNascimento == null
                        ? 'Selecionar data de nascimento'
                        : '${dataNascimento!.day.toString().padLeft(2, '0')}/'
                              '${dataNascimento!.month.toString().padLeft(2, '0')}/'
                              '${dataNascimento!.year}',
                  ),
                  trailing: const Icon(Icons.calendar_month),
                  onTap: selecionarData,
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: sexo,
                  decoration: const InputDecoration(labelText: 'Sexo'),
                  items: _sexos.entries
                      .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      sexo = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione o sexo';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                // ---------- Família ----------
                FutureBuilder<List<FamiliaModel>>(
                  future: _futureFamilias,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      );
                    }

                    if (snapshot.hasError) {
                      return Text(
                        'Não foi possível carregar as famílias.',
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                      );
                    }

                    final familias = snapshot.data ?? [];

                    return DropdownButtonFormField<int>(
                      value: familiaIdSelecionada,
                      decoration: const InputDecoration(labelText: 'Família'),
                      isExpanded: true,
                      items: familias
                          .map((f) => DropdownMenuItem(
                                value: f.id,
                                child: Text(
                                  '${f.endereco} (${f.responsavel})',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          familiaIdSelecionada = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecione a família';
                        }
                        return null;
                      },
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

            if (dataNascimento == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Selecione a data de nascimento.'),
                ),
              );
              return;
            }

            final cpfLimpo = cpfController.text.replaceAll(RegExp(r'\D'), '');

            final morador = MoradorModel(
              id: widget.morador?.id ?? 0,

              nome: nomeController.text.trim(),
              cpf: cpfLimpo,
              telefone: telefoneController.text.trim(),
              dataNascimento: dataNascimento!,
              sexo: sexo!,
              familia: familiaIdSelecionada.toString(),
            );

            Navigator.pop(context, morador);
          },
          child: Text(widget.morador == null ? 'Cadastrar' : 'Salvar'),
        ),
      ],
    );
  }
}