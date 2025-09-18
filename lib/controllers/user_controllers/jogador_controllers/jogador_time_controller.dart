import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';
import '/models/pessoa_models.dart';

class JogadorTimeController {
  final String urlBase = 'http://167.234.248.188:8080/v1';

  Future<Time?> searchJogadorTime(String cpf) async {
    final url = Uri.parse('$urlBase/time/listar-time-jogadores');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> timesJson = jsonDecode(response.body);
        for (var timeJson in timesJson) {
          final Time time = Time.fromJson(timeJson);
          if (time.jogadores != null && time.jogadores!.any((jogador) => jogador.cpf == cpf)) {
            return time;
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> exitTime(int timeId, String jogadorCpf) async {
    final url = Uri.parse('$urlBase/time/remover-jogador');

    final body = jsonEncode({
      'timeId': timeId,
      'jogadorCpf': jogadorCpf,
    });

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
