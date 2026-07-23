import 'package:flutter/material.dart';
import 'package:frontend/data/models/familia_model.dart';
import '../../shared/layouts/app_scaffold.dart';
import '../dashboard/acs_dashboard/widgets/dashboard_sidebar.dart';
import 'familia_controller.dart';
import '../../shared/widgets/app_data_table.dart';
import '../../data/models/familia_model.dart';

class FamiliaScreen extends StatefulWidget {
  const FamiliaScreen({super.key});

  @override
  State<FamiliaScreen> createState() => _FamiliaScreenState();
}

class _FamiliaScreenState extends State<FamiliaScreen> {
  final controller = FamiliaController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      sidebar: const DashboardSidebar(),

      body: FutureBuilder<List<FamiliaModel>>(
        future: controller.carregarFamilias(),

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhuma família encontrada.'));
          }

          final familias = snapshot.data ?? [];

          return Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Gestão de Famílias',
                  style: TextStyle(fontSize: 30),
                ),

                const SizedBox(height: 30),

                TextField(
                  decoration: InputDecoration(
                    hintText: 'Pesquisar...',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 30),

                Expanded(
                  child: AppDataTable(
                    columns: const [DataColumn(label: Text('Responsável'))],
                    rows: const [],
                  ),
                ),
              ],
            ),
          );

          // return SizedBox(
          //   width: double.infinity,
          //   height: double.infinity,
          //   child: Padding(
          //     padding: const EdgeInsets.all(32),

          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         LayoutBuilder(
          //           builder: (context, constraints) {
          //             return Row(
          //               children: [
          //                 Expanded(
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         'Gestão de Famílias',
          //                         style: Theme.of(
          //                           context,
          //                         ).textTheme.headlineMedium,
          //                       ),

          //                       const SizedBox(height: 6),

          //                       Text(
          //                         'Gerencie todas as famílias cadastradas.',
          //                         style: Theme.of(context).textTheme.bodyMedium,
          //                       ),
          //                     ],
          //                   ),
          //                 ),

          //                 const SizedBox(width: 20),

          //                 ElevatedButton.icon(
          //                   onPressed: () {},
          //                   icon: const Icon(Icons.add),
          //                   label: const Text('Nova Família'),
          //                 ),
          //               ],
          //             );
          //           },
          //         ),

          //         const SizedBox(height: 30),

          //         TextField(
          //           decoration: InputDecoration(
          //             hintText: 'Pesquisar família...',
          //             prefixIcon: const Icon(Icons.search),
          //             border: OutlineInputBorder(
          //               borderRadius: BorderRadius.circular(12),
          //             ),
          //           ),
          //         ),

          //         const SizedBox(height: 30),

          //         Expanded(
          //           child: Container(
          //             color: Colors.amber.shade100,
          //             child: const Center(
          //               child: Text('TESTE', style: TextStyle(fontSize: 40)),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
