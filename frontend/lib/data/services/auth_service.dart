import '../mocks/auth_mock.dart';
import '../models/usuario_model.dart';

class AuthService {
  Future<UsuarioModel?> login({
    required String cpf,
    required String senha,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    try {
      return AuthMock.usuarios.firstWhere(
        (usuario) => usuario.cpf == cpf && senha == AuthMock.senhaPadrao,
      );
    } catch (_) {
      return null;
    }
  }
}
