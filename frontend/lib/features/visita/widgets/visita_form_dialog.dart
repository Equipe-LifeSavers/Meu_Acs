import 'package:flutter/material.dart';
import '../../../data/models/visita_model.dart';

class VisitaFormDialog extends StatefulWidget {
  final VisitaModel? visita;
  const VisitaFormDialog({super.key, this.visita});
  bool get editando => visita != null;

  @override
  State<VisitaFormDialog> createState() => _VisitaFormDialogState();
}

class _VisitaFormDialogState extends State<VisitaFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final familiaController = TextEditingController();
  final agenteController = TextEditingController();
  final observacaoController = TextEditingController();

  DateTime? data;
  String tipoVisita = 'Rotina';
  String status = 'Pendente';

  @override
  void initState() {
    super.initState();
    if (widget.editando) {
      familiaController.text = widget.visita!.familia;
      agenteController.text = widget.visita!.agente;
      observacaoController.text = widget.visita!.observacao;
      data = widget.visita!.data;
      tipoVisita = widget.visita!.tipoVisita;
      status = widget.visita!.status;
    } else {
      data = DateTime.now();
    }
  }

  @override
  void dispose() {
    familiaController.dispose();
    agenteController.dispose();
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
                TextFormField(
                  controller: familiaController,
                  decoration: const InputDecoration(labelText: 'Família'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe a família';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: agenteController,
                  decoration: const InputDecoration(labelText: 'Agente'),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o agente';
                    }
                    return null;
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
                  value: tipoVisita,
                  decoration: const InputDecoration(
                    labelText: 'Tipo da visita',
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Cadastro',
                      child: Text('Cadastro'),
                    ),
                    DropdownMenuItem(value: 'Rotina', child: Text('Rotina')),
                    DropdownMenuItem(value: 'Retorno', child: Text('Retorno')),
                    DropdownMenuItem(
                      value: 'Urgência',
                      child: Text('Urgência'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      tipoVisita = value!;
                    });
                  },
                ),

                const SizedBox(height: 16),

                DropdownButtonFormField<String>(
                  value: status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: const [
                    DropdownMenuItem(
                      value: 'Pendente',
                      child: Text('Pendente'),
                    ),
                    DropdownMenuItem(
                      value: 'Realizada',
                      child: Text('Realizada'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      status = value!;
                    });
                  },
                ),

                const SizedBox(height: 16),

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
                id: widget.visita?.id ?? DateTime.now().millisecondsSinceEpoch,
                familia: familiaController.text.trim(),
                agente: agenteController.text.trim(),
                data: data!,
                tipoVisita: tipoVisita,
                observacao: observacaoController.text.trim(),
                status: status,
              ),
            );
          },
          child: Text(widget.editando ? 'Salvar Alterações' : 'Salvar'),
        ),
      ],
    );
  }
}
