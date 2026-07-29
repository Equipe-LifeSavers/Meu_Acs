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

  factory MoradorModel.fromJson(Map<String, dynamic> json) {
    return MoradorModel(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      dataNascimento: DateTime.parse(json['dataNascimento']),
      sexo: json['sexo'],
      telefone: json['telefone'] ?? '',
      // o backend só devolve o id da família (familiaId), não o nome/objeto.
      // guardamos como String aqui pra manter compatibilidade com o resto da tela;
      // se precisar exibir o nome da família, é necessário buscar via FamiliaService.
      familia: json['familiaId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'cpf': cpf,
      'dataNascimento': dataNascimento.toIso8601String().split('T').first,
      'sexo': sexo,
      'telefone': telefone,
      'familiaId': int.tryParse(familia),
    };
  }
}