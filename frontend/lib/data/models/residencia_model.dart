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

  // O backend (ResidenciaController) hoje só retorna { id, endereco, regiao }.
  // Os campos abaixo (família, tipoImovel, possuiAgua/Energia/Esgoto) NÃO existem
  // na entidade Residencia do backend ainda — ficam com valor padrão até isso
  // ser decidido (adicionar essas colunas no backend, ou remover da tela).
  factory ResidenciaModel.fromJson(Map<String, dynamic> json) {
    final regiao = json['regiao'] as Map<String, dynamic>?;

    return ResidenciaModel(
      id: json['id'],
      familia: '', // não existe no backend: Residência não sabe sua Família
      endereco: json['endereco'] ?? '',
      tipoImovel: '', // não existe no backend ainda
      possuiAgua: false, // não existe no backend ainda
      possuiEnergia: false, // não existe no backend ainda
      possuiEsgoto: false, // não existe no backend ainda
      regiaoId: regiao?['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'endereco': endereco,
      'regiaoId': regiaoId,
      // tipoImovel/possuiAgua/possuiEnergia/possuiEsgoto não são enviados:
      // o backend não tem onde guardar isso hoje.
    };
  }
}