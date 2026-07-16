import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';


class DashboardHeader extends StatelessWidget {
  final String saudacao;
  final String nome;

  const DashboardHeader({
    super.key,
    required this.saudacao,
    required this.nome,
  });

  @override
  Widget build(BuildContext context) {
    final dataHoje = DateFormat(
      "dd 'de' MMMM 'de' yyyy",
      'pt_BR',
    ).format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$saudacao, $nome!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 8),

                Text(dataHoje, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),

          IconButton(
            onPressed: () {},

            icon: const Icon(Icons.notifications_none, size: 28),
          ),

          const SizedBox(width: 10),

          const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.primary,

            child: Icon(Icons.person, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
