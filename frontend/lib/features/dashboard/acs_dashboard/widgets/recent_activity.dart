import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final atividades = [
      ('Família Silva cadastrada', '09:12'),
      ('Visita realizada na Rua José de Sá', '10:30'),
      ('Novo morador adicionado', '11:05'),
      ('Relatório enviado para UBS', '13:40'),
    ];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Atividades Recentes',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            ...atividades.map(
              (atividade) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.check, size: 18),
                ),
                title: Text(atividade.$1),
                trailing: Text(atividade.$2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
