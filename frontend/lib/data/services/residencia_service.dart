import '../models/residencia_model.dart';
import 'api_service.dart';
import 'familia_service.dart';
import '../../core/services/session_service.dart';

class ResidenciaService {
  final ApiService _api = ApiService();
  final FamiliaService _familiaService = FamiliaService();

  Future<List<ResidenciaModel>> listarResidencias() async {
    final endpoint = SessionService.instance.perfil == 'ACS'
        ? '/residencias/minha-regiao'
        : '/residencias';

    final data = await _api.get(endpoint);

    final residencias = (data as List)
        .map((json) => ResidenciaModel.fromJson(json))
        .toList();

    // Residência não sabe quem é o responsável (quem aponta pra ela é a
    // Família, não o contrário). Buscamos as famílias e cruzamos pelo
    // residenciaId pra preencher a coluna "Responsável" na tela.
    try {
      final familias = await _familiaService.listarFamilias();

      final responsavelPorResidencia = <int, String>{};

      for (final familia in familias) {
        if (familia.residenciaId != null && familia.responsavelId != null) {
          responsavelPorResidencia[familia.residenciaId!] = familia.responsavel;
        }
      }

      return residencias.map((r) {
        final nomeResponsavel = responsavelPorResidencia[r.id];

        if (nomeResponsavel == null) return r;

        return ResidenciaModel(
          id: r.id,
          familia: nomeResponsavel,
          endereco: r.endereco,
          tipoImovel: r.tipoImovel,
          possuiAgua: r.possuiAgua,
          possuiEnergia: r.possuiEnergia,
          possuiEsgoto: r.possuiEsgoto,
          regiaoId: r.regiaoId,
        );
      }).toList();
    } catch (_) {
      // Se a busca de famílias falhar, mostra as residências mesmo assim,
      // só sem o nome do responsável.
      return residencias;
    }
  }

  Future<void> adicionarResidencia(ResidenciaModel residencia) async {
    await _api.post('/residencias', residencia.toJson());
  }

  Future<void> atualizarResidencia(ResidenciaModel residencia) async {
    await _api.put('/residencias/${residencia.id}', residencia.toJson());
  }

  Future<void> excluirResidencia(int id) async {
    await _api.delete('/residencias/$id');
  }
}