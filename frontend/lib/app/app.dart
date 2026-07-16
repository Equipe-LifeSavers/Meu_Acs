import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_routes.dart';
import '../core/constants/app_strings.dart';


class MeuACSApp extends StatelessWidget {
  const MeuACSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
