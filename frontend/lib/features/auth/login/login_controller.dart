import 'package:flutter/material.dart';
import '../../../core/services/session_service.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final AuthRepository _repository = AuthRepository();

  Future<bool> login() async {
    try {
      final resposta = await _repository.login(
        email: emailController.text.trim(),
        senha: passwordController.text,
      );

      SessionService.instance.login(
        tokenJwt: resposta.token,
        perfilUsuario: resposta.perfil,
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}
