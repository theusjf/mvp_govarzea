class Despesa {
  int? id;
  String titulo;
  String descricao;
  double valor;
  String data;
  int timeId;

  Despesa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.valor,
    required this.data,
    required this.timeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'valor': valor,
      'data': data,
      'time_id': timeId,
    };
  }

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      id: map['id'],
      titulo: map['titulo'],
      descricao: map['descricao'],
      valor: map['valor'],
      data: map['data'],
      timeId: map['time_id'],
    );
  }
}
