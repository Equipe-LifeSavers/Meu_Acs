import '../models/familia_model.dart';

class FamiliaMock {
  static final List<FamiliaModel> familias = [
    FamiliaModel(
      id: 1,
      responsavel: 'Maria da Silva',
      cpfResponsavel: '12345678900',
      telefone: '(87) 99999-1111',
      endereco: 'Rua das Flores, 120',
      quantidadeMoradores: 4,
    ),

    FamiliaModel(
      id: 2,
      responsavel: 'José Pereira',
      cpfResponsavel: '98765432100',
      telefone: '(87) 99999-2222',
      endereco: 'Rua João Câmara, 45',
      quantidadeMoradores: 3,
    ),

    FamiliaModel(
      id: 3,
      responsavel: 'Ana Souza',
      cpfResponsavel: '55544433322',
      telefone: '(87) 99999-3333',
      endereco: 'Rua Nova Esperança, 87',
      quantidadeMoradores: 5,
    ),

    FamiliaModel(
      id: 4,
      responsavel: 'Carlos Oliveira',
      cpfResponsavel: '11122233344',
      telefone: '(87) 99999-4444',
      endereco: 'Rua São Pedro, 210',
      quantidadeMoradores: 2,
    ),
  ];
}
