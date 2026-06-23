import 'package:flutter/material.dart';

import '../features/auth/login/login_screen.dart';

class AppRoutes {
  static const String login = '/';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
  };
}