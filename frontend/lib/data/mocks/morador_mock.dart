import '../models/morador_model.dart';

// Remover este mock quando o endpoint GET /moradores estiver integrado.
class MoradorMock {
  static final List<MoradorModel> moradores = [
    MoradorModel(
      id: 1,
      nome: 'Maria Silva',
      cpf: '123.456.789-00',
      dataNascimento: DateTime(1985, 5, 10),
      sexo: 'Feminino',
      telefone: '(85) 99999-1111',
      familia: 'Maria Silva',
    ),
    MoradorModel(
      id: 2,
      nome: 'José Silva',
      cpf: '987.654.321-00',
      dataNascimento: DateTime(1982, 9, 20),
      sexo: 'Masculino',
      telefone: '(85) 99999-2222',
      familia: 'Maria Silva',
    ),
    MoradorModel(
      id: 3,
      nome: 'Ana Pereira',
      cpf: '111.222.333-44',
      dataNascimento: DateTime(2008, 3, 15),
      sexo: 'Feminino',
      telefone: '(85) 98888-3333',
      familia: 'João Pereira',
    ),
    MoradorModel(
      id: 4,
      nome: 'João Pereira',
      cpf: '555.666.777-88',
      dataNascimento: DateTime(1980, 12, 1),
      sexo: 'Masculino',
      telefone: '(85) 98888-2222',
      familia: 'João Pereira',
    ),
    MoradorModel(
      id: 5,
      nome: 'Pedro Pereira',
      cpf: '999.888.777-66',
      dataNascimento: DateTime(2015, 7, 5),
      sexo: 'Masculino',
      telefone: '',
      familia: 'João Pereira',
    ),
  ];
}
