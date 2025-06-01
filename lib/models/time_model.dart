import 'dart:io';

class Time {
  final String nome;
  final File foto;

  Time ({
    required this.nome,
    required this.foto,
  });
}

final List<Time> times = [
  Time(nome: 'Amigos da Varzea', foto: File('assets/time1.png')),
  Time(nome: 'Real Pirituba', foto: File('assets/time2.png')),
  Time(nome: 'Unidos da Vila', foto: File('assets/time3.png')),
  Time(nome: 'AliançaFut', foto: File('assets/time4.png')),
];