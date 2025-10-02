class Noticia {
  int? id;
  String? titulo;
  String? conteudo;
  DateTime? dataPublicacao;
  int? idTime;

  Noticia({this.id, this.titulo, this.conteudo, this.dataPublicacao, this.idTime});

  factory Noticia.fromJson(Map<String, dynamic> json) => Noticia(
    id: json['id'] as int?,
    titulo: json['titulo'] as String?,
    conteudo: json['conteudo'] as String?,
    dataPublicacao: json['dataPublicacao'] != null ? DateTime.parse(json['dataPublicacao']) : null,
    idTime: json['idTime'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'conteudo': conteudo,
    'dataPublicacao': dataPublicacao?.toIso8601String(),
    'idTime': idTime,
  };
}