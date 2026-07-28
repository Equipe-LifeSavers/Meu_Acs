import '../../data/models/usuario_model.dart';

class SessionService {
  SessionService._();

  static final SessionService instance = SessionService._();

  UsuarioModel? usuario;
  String? token;
  String? perfil;
  bool get isLogged => token != null;

  void login({
    UsuarioModel? usuarioLogado,
    required String tokenJwt,
    required String perfilUsuario,
  }) {
    usuario = usuarioLogado;
    token = tokenJwt;
    perfil = perfilUsuario;
  }

  void logout() {
    usuario = null;
    token = null;
    perfil = null;
  }
}