import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const _InitialPlaceholderScreen(),
  };
}

class _InitialPlaceholderScreen extends StatelessWidget {
  const _InitialPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Meu ACS',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}