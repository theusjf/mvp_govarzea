enum Role { ROLE_Jogador, ROLE_Dirigente, ROLE_Torcedor }

class Pessoa {
  final String cpf;
  final String nome;
  final String email;
  final String telefone;
  final String senha;
  Role? tipoPerfil;
  final String? foto;

  Pessoa({
    required this.cpf,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.senha,
    this.tipoPerfil,
    this.foto,
  });

  factory Pessoa.fromJson(Map<String, dynamic> json) {
    Role? perfil;
    if (json['tipoPerfil'] != null) {
      perfil = Role.values.firstWhere(
            (e) => e.name == json['tipoPerfil'],
        orElse: () => Role.ROLE_Jogador,
      );
    } else {
    }
    return Pessoa(
      cpf: json['cpf'] ?? '',
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      telefone: json['telefone'] ?? '',
      senha: json['senha'] ?? '',
      tipoPerfil: perfil,
      foto: json['foto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'senha': senha,
      'tipoPerfil': tipoPerfil?.name,
      'foto': foto,
    };
  }
}


class Dirigente {
  final String cpf;
  final String cargo;
  final Pessoa pessoa;

  Dirigente({
    required this.cpf,
    required this.cargo,
    required this.pessoa,
  });

  factory Dirigente.fromJson(Map<String, dynamic> json) {
    return Dirigente(
      cpf: json['cpf'] ?? '',
      cargo: json['cargo'] ?? '',
      pessoa: Pessoa.fromJson(json['pessoa'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'cargo': cargo,
      'pessoa': pessoa.toJson(),
    };
  }
}


class Jogador {
  final String cpf;
  final String? apelido;
  final String? numeroCamisa;
  final Pessoa pessoa;

  Jogador({
    required this.cpf,
    this.apelido,
    this.numeroCamisa,
    required this.pessoa,
  });

  factory Jogador.fromJson(Map<String, dynamic> json) {
    return Jogador(
      cpf: json['cpf'] ?? '',
      apelido: json['apelido'],
      numeroCamisa: json['numeroCamisa'],
      pessoa: Pessoa.fromJson(json['pessoa'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'apelido': apelido,
      'numeroCamisa': numeroCamisa,
      'pessoa': pessoa.toJson(),
    };
  }
}


class Torcedor {
  final String cpf;
  final String biografia;
  final Pessoa pessoa;

  Torcedor({
    required this.cpf,
    required this.biografia,
    required this.pessoa,
  });

  factory Torcedor.fromJson(Map<String, dynamic> json) {
    return Torcedor(
      cpf: json['cpf'] ?? '',
      biografia: json['biografia'] ?? '',
      pessoa: Pessoa.fromJson(json['pessoa'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cpf': cpf,
      'biografia': biografia,
      'pessoa': pessoa.toJson(),
    };
  }
}
