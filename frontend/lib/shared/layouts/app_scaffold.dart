import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AppScaffold extends StatelessWidget {
  final Widget sidebar;
  final Widget body;

  const AppScaffold({super.key, required this.sidebar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Row(
          children: [
            sidebar,

            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}
