import 'dart:io';

class Usuario {
  final int id;
  final String nome;
  final String cpf;
  final String email;
  final String senha;
  final String telefone;
  final DateTime dataNasc;
  final File? foto;

  Usuario({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.dataNasc,
    this.foto,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      cpf: json['cpf'],
      email: json['email'],
      senha: json['senha'],
      telefone: json['telefone'],
      dataNasc: DateTime.parse(json['dataNasc']),
      foto: json['fotoPath'] != null ? File(json['fotoPath']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'dataNasc': dataNasc.toIso8601String(),
      'fotoPath': foto?.path,
    };
  }
}

class Torcedor {
  final Usuario usuario;

  Torcedor({
    required this.usuario,
  });

  factory Torcedor.fromJson(Map<String, dynamic> json) {
    return Torcedor(
      usuario: Usuario.fromJson(json['usuario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
    };
  }
}

class Jogador {
  final Usuario usuario;

  Jogador({
    required this.usuario,
  });

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      usuario: Usuario.fromJson(json['usuario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
    };
  }
}

class Dirigente {
  final Usuario usuario;

  Dirigente({
    required this.usuario,
  });

  factory Dirigente.fromJson(Map<String, dynamic> json) {
    return Dirigente(
      usuario: Usuario.fromJson(json['usuario']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
    };
  }
}

final Usuario usuario1 = Usuario(
  id: 1,
  nome: 'Matheus Francisco',
  cpf: '111.111.111-00',
  email: 'matheus@email.com',
  senha: '12345678',
  telefone: '(11) 11111-1111',
  dataNasc: DateTime(2004, 4, 29),
  foto: null,
);

final Usuario usuario2 = Usuario(
  id: 2,
  nome: 'Ana Pereira',
  cpf: '987.654.321-00',
  email: 'ana.pereira@email.com',
  senha: 'senha5678',
  telefone: '(21) 99876-5432',
  dataNasc: DateTime(1995, 11, 10),
  foto: null,
);

final Usuario usuario3 = Usuario(
  id: 3,
  nome: 'João Souza',
  cpf: '456.789.123-00',
  email: 'joao.souza@email.com',
  senha: 'senha9012',
  telefone: '(31) 98765-4321',
  dataNasc: DateTime(1985, 3, 15),
  foto: null,
);
