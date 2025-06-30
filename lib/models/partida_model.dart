import 'time_model.dart';

class Partida {
  final Time time1;
  final Time time2;
  final String data;
  final String local;

  Partida({
    required this.time1,
    required this.time2,
    required this.data,
    required this.local,
  });

  factory Partida.fromJson(Map<String, dynamic> json) {
    return Partida(
      time1: times.firstWhere(
            (t) => t.nome == json['time1'],
        orElse: () => Time(nome: json['time1']),
      ),
      time2: times.firstWhere(
            (t) => t.nome == json['time2'],
        orElse: () => Time(nome: json['time2']),
      ),
      data: json['data'],
      local: json['local'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time1': time1.nome,
      'time2': time2.nome,
      'data': data,
      'local': local,
    };
  }
}
