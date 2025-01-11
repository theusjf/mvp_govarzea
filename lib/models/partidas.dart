import 'dart:io';
import 'times.dart';

class Partida {
  final Time time1;
  final Time time2;
  final DateTime data;
  final String local;

  Partida({
    required this.time1,
    required this.time2,
    required this.data,
    required this.local,
});
}

final List<Partida> partidas = [];