import '../models/login_response_model.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _service = AuthService();

  Future<LoginResponseModel> login({
    required String email,
    required String senha,
  }) {
    return _service.login(
      email: email,
      senha: senha,
    );
  }
}