import '../models/residencia_model.dart';

class ResidenciaMock {
  static final List<ResidenciaModel> residencias = [
    const ResidenciaModel(
      id: 1,
      familia: 'João da Silva',
      endereco: 'Rua das Flores, 120',
      tipoImovel: 'Alvenaria',
      possuiAgua: true,
      possuiEnergia: true,
      possuiEsgoto: true,
    ),

    const ResidenciaModel(
      id: 2,
      familia: 'Maria Oliveira',
      endereco: 'Rua Ceará, 250',
      tipoImovel: 'Madeira',
      possuiAgua: true,
      possuiEnergia: true,
      possuiEsgoto: false,
    ),

    const ResidenciaModel(
      id: 3,
      familia: 'José Pereira',
      endereco: 'Rua Central, 55',
      tipoImovel: 'Mista',
      possuiAgua: true,
      possuiEnergia: false,
      possuiEsgoto: false,
    ),
  ];
}
