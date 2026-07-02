import '../models/usuario_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<UsuarioModel?> login({required String cpf, required String senha}) {
    return _service.login(cpf: cpf, senha: senha);
  }
}
