import 'dart:convert';
import 'package:http/http.dart' as http;
import '../mocks/auth_mock.dart';
import '../models/login_response_model.dart';
import '../models/usuario_model.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080';

  // ==========================================================
  // CONFIGURAÇÃO TEMPORÁRIA
  //
  // true  = utiliza dados mockados
  // false = utiliza o backend
  // ==========================================================
  static const bool usarMock = false;

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

    if (response.statusCode != 200) {
      throw Exception('E-mail ou senha inválidos');
    }

    final loginJson = jsonDecode(response.body);
    final token = loginJson['token'] as String;
    final perfil = loginJson['perfil'] as String;

    // O /auth/login não devolve os dados do usuário (nome, email, id),
    // só o token e o perfil. Buscamos o resto com o token recém-obtido.
    final usuario = await _buscarPerfil(token);

    return LoginResponseModel(
      token: token,
      perfil: perfil,
      usuario: usuario,
    );
  }

  Future<UsuarioModel?> _buscarPerfil(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/perfil'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return UsuarioModel.fromJson(jsonDecode(response.body));
      }
    } catch (_) {
      // Se falhar, segue o login mesmo assim -- o nome só não aparece
      // corretamente na tela, mas o usuário não fica travado no login.
    }

    return null;
  }
}