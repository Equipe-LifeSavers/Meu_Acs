import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/services/session_service.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};

    final token = SessionService.instance.token;

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<dynamic> get(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );

    return _handle(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );

    return _handle(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
      body: jsonEncode(body),
    );

    return _handle(response);
  }

  Future<void> delete(String endpoint) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );

    _handle(response, esperaCorpo: false);
  }

  /// Usado para endpoints que retornam arquivo binário (ex: PDF),
  /// em vez de JSON. Não passa pelo _handle porque o corpo não é texto.
  Future<List<int>> getBytes(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: _headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return response.bodyBytes;
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sessão expirada ou sem permissão para essa ação.');
    }

    throw Exception('Erro ao gerar arquivo (${response.statusCode}).');
  }

  dynamic _handle(http.Response response, {bool esperaCorpo = true}) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (!esperaCorpo || response.body.isEmpty) {
        return null;
      }

      return jsonDecode(response.body);
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      throw Exception('Sessão expirada ou sem permissão para essa ação.');
    }

    throw Exception('Erro na requisição (${response.statusCode}): ${response.body}');
  }
}