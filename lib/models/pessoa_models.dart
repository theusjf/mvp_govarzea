import 'dart:io';

enum Funcao { Torcedor, Jogador, Dirigente }

class Usuario {
  final String cpf;
  final String nome;
  final String email;
  final String senha;
  final String telefone;
  final Funcao funcao;
  final String? foto;

  Usuario({
    required this.cpf,
    required this.nome,
    required this.email,
    required this.senha,
    required this.telefone,
    required this.funcao,
    this.foto,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      cpf: json['cpf'],
      nome: json['nome'],
      email: json['email'],
      senha: json['senha'],
      telefone: json['telefone'],
      funcao: Funcao.values.firstWhere((e) => e.name == json['tipoPerfil']),
      foto: json['fotoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'tipoPerfil': funcao.name,
      'fotoUrl': foto,
    };
  }
}

class Torcedor {
  final Usuario usuario;

  Torcedor({required this.usuario});

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
  final String apelido;
  final String numeroCamisa;

  Jogador({
    required this.usuario,
    required this.apelido,
    required this.numeroCamisa,
  });

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      usuario: Usuario.fromJson(json['usuario']),
      apelido: json['apelido'],
      numeroCamisa: json['numeroCamisa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'apelido': apelido,
      'numeroCamisa': numeroCamisa,
    };
  }
}


class Dirigente {
  final Usuario usuario;
  final String cargo;

  Dirigente({
    required this.usuario,
    required this.cargo,
  });

  factory Dirigente.fromJson(Map<String, dynamic> json) {
    return Dirigente(
      usuario: Usuario.fromJson(json['usuario']),
      cargo: json['cargo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'cargo': cargo,
    };
  }
}



