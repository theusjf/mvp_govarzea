import '/models/partida_model.dart';
import '/models/time_model.dart';

class CriarPartidaController {
  Time? time1;
  Time? time2;
  String? data;
  String? local;

  Partida? criarPartida() {
    if (time1 != null && time2 != null && data != null && data!.isNotEmpty && local != null && local!.isNotEmpty) {
      return Partida(
        time1: time1!,
        time2: time2!,
        data: data!,
        local: local!,
      );
    }
    return null;
  }
}
