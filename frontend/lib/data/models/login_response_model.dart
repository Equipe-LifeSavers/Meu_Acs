import 'usuario_model.dart';

class LoginResponseModel {
  final String token;
  final String perfil;
  final UsuarioModel? usuario;

  const LoginResponseModel({
    required this.token,
    required this.perfil,
    this.usuario,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      perfil: json['perfil'],
      usuario: null,
    );
  }
}
