import '../../data/models/usuario_model.dart';

class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();

  UsuarioModel? usuario;

  bool get isLogged => usuario != null;

  void login(UsuarioModel usuarioLogado) {
    usuario = usuarioLogado;
  }

  void logout() {
    usuario = null;
  }
}
