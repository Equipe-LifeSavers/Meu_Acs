import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController {
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();

  Future<bool> login() async {
    final usuario = await _authRepository.login(
      cpf: cpfController.text.trim(),
      senha: passwordController.text.trim(),
    );
    return usuario != null;
  }

  void dispose() {
    cpfController.dispose();
    passwordController.dispose();
  }
}
