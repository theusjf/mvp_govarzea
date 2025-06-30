import '/models/partida_model.dart';

class PainelController {
  final List<Partida> _partidas = [];

  List<Partida> searchPartidas() {
    return _partidas;
  }

  void addPartida(Partida partida) {
    _partidas.add(partida);
  }
}
