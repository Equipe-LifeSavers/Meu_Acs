class UsuarioModel {
  final int id;
  final String nome;
  final String email;
  final String perfil;

  const UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.perfil,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      perfil: json['perfil'],
    );
  }
}