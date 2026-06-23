import 'package:flutter/material.dart';

class LoginController {
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  void dispose() {
    cpfController.dispose();
    passwordController.dispose();
  }
}