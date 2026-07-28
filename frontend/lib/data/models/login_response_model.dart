class LoginResponseModel {
  final String token;
  final String perfil;

  const LoginResponseModel({
    required this.token,
    required this.perfil,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      perfil: json['perfil'],
    );
  }
}