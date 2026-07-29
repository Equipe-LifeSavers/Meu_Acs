import '../mocks/residencia_mock.dart';
import '../models/residencia_model.dart';

class ResidenciaService {
  Future<List<ResidenciaModel>> listarResidencias() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(ResidenciaMock.residencias);

    //  Substituir pela chamada GET /residencias
  }

  Future<void> adicionarResidencia(ResidenciaModel residencia) async {
    await Future.delayed(const Duration(milliseconds: 300));

    ResidenciaMock.residencias.add(residencia);

    //  Substituir pela chamada POST /residencias
  }

  Future<void> atualizarResidencia(ResidenciaModel residencia) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final index = ResidenciaMock.residencias.indexWhere(
      (r) => r.id == residencia.id,
    );

    if (index != -1) {
      ResidenciaMock.residencias[index] = residencia;
    }

    //  Substituir pela chamada PUT /residencias/{id}
  }

  Future<void> excluirResidencia(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    ResidenciaMock.residencias.removeWhere(
      (r) => r.id == id,
    );

    //  Substituir pela chamada DELETE /residencias/{id}
  }
}