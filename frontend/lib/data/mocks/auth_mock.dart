import '../models/usuario_model.dart';

class AuthMock {
  static const String senhaPadrao = '123456';

  static const List<UsuarioModel> usuarios = [
    UsuarioModel(
      id: 1,
      nome: 'Administrador',
      email: 'admin@meuacs.com',
      perfil: 'ADMIN',
    ),

    UsuarioModel(
      id: 2,
      nome: 'UBS Centro',
      email: 'ubs@meuacs.com',
      perfil: 'UBS',
    ),

    UsuarioModel(
      id: 3,
      nome: 'Maria Oliveira',
      email: 'acs@meuacs.com',
      perfil: 'ACS',
    ),
  ];
}
