//Adicionar factory fromJson() para desserialização da API.

class MoradorModel {
  final int id;
  final String nome;
  final String cpf;
  final DateTime dataNascimento;
  final String sexo;
  final String telefone;
  final String familia;

  const MoradorModel({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.sexo,
    required this.telefone,
    required this.familia,
  });

  int get idade {
    final hoje = DateTime.now();

    int idade = hoje.year - dataNascimento.year;

    if (hoje.month < dataNascimento.month || (hoje.month == dataNascimento.month && hoje.day < dataNascimento.day)){
      idade--;
    }

    return idade;
  }
}
