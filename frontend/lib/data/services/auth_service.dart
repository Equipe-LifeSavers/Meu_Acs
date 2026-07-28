import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response_model.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080';

  Future<LoginResponseModel> login({
    required String email,
    required String senha,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(jsonDecode(response.body));
    }

    throw Exception('Email ou senha inválidos');
  }
}
