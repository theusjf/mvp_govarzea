class Despesa {
  int? id;
  String titulo;
  double valor;
  String data;
  int timeId;

  Despesa({
    this.id,
    required this.titulo,
    required this.valor,
    required this.data,
    required this.timeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'valor': valor,
      'data': data,
      'time_id': timeId,
    };
  }

  factory Despesa.fromMap(Map<String, dynamic> map) {
    return Despesa(
      id: map['id'],
      titulo: map['titulo'],
      valor: map['valor'],
      data: map['data'],
      timeId: map['time_id'],
    );
  }
}
