import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import 'app_routes.dart';
import '../core/constants/app_strings.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


class MeuACSApp extends StatelessWidget {
  const MeuACSApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      routerConfig: AppRoutes.router,
    );
  }
}
