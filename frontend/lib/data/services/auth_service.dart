import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mocks/auth_mock.dart';
import '../models/login_response_model.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080';

  // ==========================================================
  // CONFIGURAÇÃO TEMPORÁRIA
  //
  // true  = utiliza dados mockados
  // false = utiliza o backend
  //
  // Ao finalizando as telas, alterar para false.
  // ==========================================================
  static const bool usarMock = true;

  Future<LoginResponseModel> login({
    required String email,
    required String senha,
  }) async {
    if (usarMock) {
      // ==========================================================
      // MOCK TEMPORÁRIO
      //
      // Remover este bloco após finalizar a integração.
      // ==========================================================

      await Future.delayed(const Duration(seconds: 1));

      try {
        final usuario = AuthMock.usuarios.firstWhere(
          (u) =>
              u.email.toLowerCase() == email.toLowerCase() &&
              senha == AuthMock.senhaPadrao,
        );

        return LoginResponseModel(
          token: 'mock-token',
          perfil: usuario.perfil,
          usuario: usuario,
        );
      } catch (_) {
        throw Exception('E-mail ou senha inválidos');
      }
    }

    // ==========================================================
    // BACKEND
    // ==========================================================

    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('E-mail ou senha inválidos');
  }
}
