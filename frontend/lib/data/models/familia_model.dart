/// Modelo utilizado pela tela de Famílias.
class FamiliaModel {
  final int id;
  final String responsavel;
  final String cpfResponsavel;
  final String telefone;
  final String endereco;
  final int quantidadeMoradores;

  // Necessários para criar/atualizar (o backend exige os IDs, não os textos).
  final int? residenciaId;
  final int? responsavelId;

  const FamiliaModel({
    required this.id,
    required this.responsavel,
    required this.cpfResponsavel,
    required this.telefone,
    required this.endereco,
    required this.quantidadeMoradores,
    this.residenciaId,
    this.responsavelId,
  });

  factory FamiliaModel.fromJson(Map<String, dynamic> json) {
    final residencia = json['residencia'] as Map<String, dynamic>?;
    final responsavel = json['responsavel'] as Map<String, dynamic>?;
    final moradores = json['moradores'] as List?;

    return FamiliaModel(
      id: json['id'],
      responsavel: responsavel?['nome'] ?? 'Sem responsável definido',
      cpfResponsavel: responsavel?['cpf'] ?? '',
      telefone: responsavel?['telefone'] ?? '',
      endereco: residencia?['endereco'] ?? '',
      quantidadeMoradores: moradores?.length ?? 0,
      residenciaId: residencia?['id'],
      responsavelId: responsavel?['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'residenciaId': residenciaId,
      'responsavelId': responsavelId,
    };
  }
}