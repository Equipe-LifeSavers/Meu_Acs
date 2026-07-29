import 'package:flutter/material.dart';
import '../../../data/models/relatorio_model.dart';

class RelatorioDetailDialog extends StatelessWidget {
  final RelatorioModel relatorio;
  const RelatorioDetailDialog({super.key, required this.relatorio});

  Widget item(String titulo, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              titulo,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(flex: 3, child: Text(valor)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Detalhes do Relatório'),

      content: SizedBox(
        width: 520,

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              item('Região', relatorio.regiao),
              item('UBS', relatorio.ubs),

              const Divider(),

              item('ACS', relatorio.totalAcs.toString()),
              item('Residências', relatorio.totalResidencias.toString()),
              item('Famílias', relatorio.totalFamilias.toString()),
              item('Moradores', relatorio.totalMoradores.toString()),
              item('Visitas', relatorio.totalVisitas.toString()),
              item('Realizadas', relatorio.visitasRealizadas.toString()),
              item('Pendentes', relatorio.visitasPendentes.toString()),
            ],
          ),
        ),
      ),

      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
