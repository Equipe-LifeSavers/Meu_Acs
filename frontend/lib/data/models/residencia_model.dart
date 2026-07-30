class ResidenciaModel {
  final int id;
  final String familia;
  final String endereco;
  final String tipoImovel;
  final bool possuiAgua;
  final bool possuiEnergia;
  final bool possuiEsgoto;

  // Necessário para criar/atualizar (o backend exige o id da região).
  final int? regiaoId;

  const ResidenciaModel({
    required this.id,
    required this.familia,
    required this.endereco,
    required this.tipoImovel,
    required this.possuiAgua,
    required this.possuiEnergia,
    required this.possuiEsgoto,
    this.regiaoId,
  });

  // O backend agora retorna { id, endereco, tipoImovel, possuiAgua,
  // possuiEnergia, possuiEsgoto, regiao }.
  // 'familia' continua sem equivalente: Residência não sabe sua Família
  // (é a Família que aponta pra Residência, não o contrário).
  factory ResidenciaModel.fromJson(Map<String, dynamic> json) {
    final regiao = json['regiao'] as Map<String, dynamic>?;

    return ResidenciaModel(
      id: json['id'],
      familia: '',
      endereco: json['endereco'] ?? '',
      tipoImovel: json['tipoImovel'] ?? '',
      possuiAgua: json['possuiAgua'] ?? false,
      possuiEnergia: json['possuiEnergia'] ?? false,
      possuiEsgoto: json['possuiEsgoto'] ?? false,
      regiaoId: regiao?['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endereco': endereco,
      'tipoImovel': tipoImovel,
      'possuiAgua': possuiAgua,
      'possuiEnergia': possuiEnergia,
      'possuiEsgoto': possuiEsgoto,
      'regiaoId': regiaoId,
    };
  }
}