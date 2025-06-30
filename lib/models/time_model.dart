import 'pessoa_models.dart';

class Time {
  final int? idTime;
  final String nome;
  final String? localizacao;
  final DateTime? fundacao;
  final Dirigente? dirigente;
  final List<Jogador>? jogadores;

  Time({
    this.idTime,
    required this.nome,
    this.localizacao,
    this.fundacao,
    this.dirigente,
    this.jogadores,
  });

  factory Time.fromJson(Map<String, dynamic> json) {
    return Time(
      idTime: json['idTime'],
      nome: json['nome'],
      localizacao: json['localizacao'],
      fundacao: json['fundacao'] != null
          ? DateTime.tryParse(json['fundacao'])
          : null,
      dirigente: json['fkDirigente'] != null
          ? Dirigente.fromJson(json['fkDirigente'])
          : null,
      jogadores: json['jogadores'] != null
          ? (json['jogadores'] as List)
          .map((j) => Jogador.fromJson(j))
          .toList()
          : [],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'idTime': idTime,
      'nome': nome,
      'localizacao': localizacao,
      'fundacao': fundacao?.toIso8601String(),
      'dirigente': dirigente?.toJson(),
      'jogadores': jogadores?.map((j) => j.toJson()).toList(),
    };
  }
}




final List<Time> times = [
  Time(nome: 'Amigos da Varzea'),
  Time(nome: 'Real Pirituba',),
  Time(nome: 'Unidos da Vila'),
  Time(nome: 'AliançaFut'),
];

