import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_routes.dart';

class MeuACSApp extends StatelessWidget {
  const MeuACSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu ACS',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}