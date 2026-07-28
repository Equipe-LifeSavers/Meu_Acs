import 'package:flutter/material.dart';
import '../../../data/models/morador_model.dart';

class MoradorFormDialog extends StatefulWidget {
  final MoradorModel? morador;
  const MoradorFormDialog({super.key, this.morador});

  @override
  State<MoradorFormDialog> createState() => _MoradorFormDialogState();
}

class _MoradorFormDialogState extends State<MoradorFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();

  DateTime? dataNascimento;
  String? sexo;
  String? familia;

  // Carregar lista através do endpoint GET /familias.
  final List<String> familias = const ['Maria Silva', 'João Pereira'];

  @override
  void initState() {
    super.initState();

    if (widget.morador != null) {
      final morador = widget.morador!;

      nomeController.text = morador.nome;
      cpfController.text = morador.cpf;
      telefoneController.text = morador.telefone;

      dataNascimento = morador.dataNascimento;
      sexo = morador.sexo;
      familia = morador.familia;
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
                  decoration: const InputDecoration(labelText: 'CPF'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o CPF';
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
                  items: const [
                    DropdownMenuItem(
                      value: 'Masculino',
                      child: Text('Masculino'),
                    ),
                    DropdownMenuItem(
                      value: 'Feminino',
                      child: Text('Feminino'),
                    ),
                  ],
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

                DropdownButtonFormField<String>(
                  value: familia,
                  decoration: const InputDecoration(labelText: 'Família'),
                  items: familias.map((f) {
                    return DropdownMenuItem(value: f, child: Text(f));
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      familia = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione a família';
                    }
                    return null;
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

            final morador = MoradorModel(
              id: widget.morador?.id ?? DateTime.now().millisecondsSinceEpoch,

              nome: nomeController.text,
              cpf: cpfController.text,
              telefone: telefoneController.text,
              dataNascimento: dataNascimento!,
              sexo: sexo!,
              familia: familia!,
            );

            Navigator.pop(context, morador);
          },
          child: Text(widget.morador == null ? 'Cadastrar' : 'Salvar'),
        ),
      ],
    );
  }
}
