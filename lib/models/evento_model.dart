class Evento {
  int? id;
  String? titulo;
  String? conteudo;
  DateTime? data;
  String? foto;
  int? timeId;

  Evento({this.id, this.titulo, this.conteudo, this.data, this.foto, this.timeId});

  factory Evento.fromJson(Map<String, dynamic> json) => Evento(
    id: json['id'] as int?,
    titulo: json['titulo'] as String?,
    conteudo: json['conteudo'] as String?,
    data: json['data'] != null ? DateTime.parse(json['data']) : null,
    foto: json['foto'] as String?,
    timeId: json['timeId'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'conteudo': conteudo,
    'data': data?.toIso8601String(),
    'foto': foto,
    'timeId': timeId,
  };
}