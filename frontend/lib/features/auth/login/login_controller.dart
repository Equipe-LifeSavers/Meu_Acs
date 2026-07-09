import 'package:flutter/material.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../core/services/session_service.dart';

class LoginController {
  final cpfController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthRepository _authRepository = AuthRepository();

  Future<bool> login() async {
    final usuario = await _authRepository.login(
      cpf: cpfController.text,
      senha: passwordController.text,
    );

    if (usuario != null) {
      SessionService.instance.login(usuario);
      return true;
    }
    return false;
  }

  void dispose() {
    cpfController.dispose();
    passwordController.dispose();
  }
}
