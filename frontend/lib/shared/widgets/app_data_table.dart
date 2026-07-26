import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const AppDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: DataTable2(
          columns: columns,
          rows: rows,

          minWidth: 1000,

          columnSpacing: 20,
          horizontalMargin: 16,

          headingRowHeight: 56,
          dataRowHeight: 64,

          dividerThickness: .6,

          showCheckboxColumn: false,
        ),
      ),
    );
  }
}
