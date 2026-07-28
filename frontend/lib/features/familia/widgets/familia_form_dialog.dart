import 'package:flutter/material.dart';
import '../../../data/models/familia_model.dart';

class FamiliaFormDialog extends StatefulWidget {
  final FamiliaModel? familia;
  const FamiliaFormDialog({super.key, this.familia});
  bool get editando => familia != null;

  @override
  State<FamiliaFormDialog> createState() => _FamiliaFormDialogState();
}

class _FamiliaFormDialogState extends State<FamiliaFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final responsavelController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();
  final enderecoController = TextEditingController();
  final moradoresController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.familia != null) {
      responsavelController.text = widget.familia!.responsavel;
      cpfController.text = widget.familia!.cpfResponsavel;
      telefoneController.text = widget.familia!.telefone;
      enderecoController.text = widget.familia!.endereco;
      moradoresController.text = widget.familia!.quantidadeMoradores.toString();
    }
  }

  @override
  void dispose() {
    responsavelController.dispose();
    cpfController.dispose();
    telefoneController.dispose();
    enderecoController.dispose();
    moradoresController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.editando ? 'Editar Família' : 'Nova Família'),

      content: SizedBox(
        width: 450,

        child: Form(
          key: _formKey,

          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: responsavelController,
                decoration: const InputDecoration(labelText: 'Responsável'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o responsável';
                  }

                  if (value.trim().length < 3) {
                    return 'Nome muito curto';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: cpfController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'CPF'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o CPF';
                  }

                  if (value.trim().length != 11) {
                    return 'CPF deve conter 11 números';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o telefone';
                  }
                  return null;
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

              TextFormField(
                controller: moradoresController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Quantidade de moradores',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a quantidade';
                  }
                  final numero = int.tryParse(value);
                  if (numero == null || numero <= 0) {
                    return 'Quantidade inválida';
                  }
                  return null;
                },
              ),
            ],
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
              id: widget.familia?.id ?? DateTime.now().millisecondsSinceEpoch,
              responsavel: responsavelController.text.trim(),
              cpfResponsavel: cpfController.text.trim(),
              telefone: telefoneController.text.trim(),
              endereco: enderecoController.text.trim(),
              quantidadeMoradores: int.parse(moradoresController.text),
            );

            Navigator.pop(context, familia);
          },
          child: Text(widget.editando ? 'Salvar Alterações' : 'Salvar'),
        ),
      ],
    );
  }
}
