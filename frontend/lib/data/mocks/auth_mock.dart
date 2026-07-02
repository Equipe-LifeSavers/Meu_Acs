import '../models/usuario_model.dart';

class AuthMock {
  static final List<UsuarioModel> usuarios = [
    UsuarioModel(id: 1, nome: 'Maria Silva', cpf: '12345678900', perfil: 'ACS'),

    UsuarioModel(id: 2, nome: 'UBS Salgueiro', cpf: '00000000000', perfil: 'UBS',),

  ];
  static const String senhaPadrao = '123456';
}
