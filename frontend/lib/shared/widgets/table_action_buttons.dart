import 'package:flutter/material.dart';

class TableActionButtons extends StatelessWidget {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onPdf;

  const TableActionButtons({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onPdf,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null)
          IconButton(
            tooltip: 'Visualizar',
            visualDensity: VisualDensity.compact,
            splashRadius: 20,
            icon: const Icon(
              Icons.visibility_outlined,
              color: Colors.blue,
              size: 20,
            ),
            onPressed: onView,
          ),

        if (onEdit != null)
          IconButton(
            tooltip: 'Editar',
            visualDensity: VisualDensity.compact,
            splashRadius: 20,
            icon: const Icon(
              Icons.edit_outlined,
              color: Colors.orange,
              size: 20,
            ),
            onPressed: onEdit,
          ),

        if (onDelete != null)
          IconButton(
            tooltip: 'Excluir',
            visualDensity: VisualDensity.compact,
            splashRadius: 20,
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
            onPressed: onDelete,
          ),

        if (onPdf != null)
          IconButton(
            tooltip: 'Gerar PDF',
            visualDensity: VisualDensity.compact,
            splashRadius: 20,
            icon: const Icon(
              Icons.picture_as_pdf_outlined,
              color: Colors.red,
              size: 20,
            ),
            onPressed: onPdf,
          ),
      ],
    );
  }
}
