import 'package:flutter/material.dart';

class AppDataTable extends StatelessWidget {
  final List<DataColumn> columns;
  final List<DataRow> rows;

  const AppDataTable({super.key, required this.columns, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: DataTable(
            headingRowHeight: 60,
            dataRowMinHeight: 60,
            dataRowMaxHeight: 70,
            horizontalMargin: 20,
            columnSpacing: 32,
            columns: columns,
            rows: rows,
          ),
        ),
      ),
    );
  }
}
