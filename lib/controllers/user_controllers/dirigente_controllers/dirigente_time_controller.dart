import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';

class DirigenteTimeController {
  final String urlBase = 'http://167.234.248.188:8080/v1';

  Future<List<Time>> listTimes() async {
    final url = Uri.parse('$urlBase/time/listar-time-jogadores');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Time.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao listar times: ${response.statusCode}');
    }
  }

  Future<bool> removerTime(int idTime) async {
    final times = await listTimes();
    final time = times.firstWhere((t) => t.idTime == idTime);

    if (time != null && time.jogadores != null && time.jogadores!.isNotEmpty) {
      for (final jogador in time.jogadores!) {
        final res = await removerJogador(idTime, jogador.cpf);
        if (!res) return false;
      }
    }

    final url = Uri.parse('$urlBase/time/$idTime');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> editarTime(Time time) async {
    if (time.idTime == null) return false;

    final url = Uri.parse('$urlBase/time/${time.idTime}');
    final body = {
      'idTime': time.idTime,
      'nome': time.nome,
      'localizacao': time.localizacao ?? 'Local não informado',
      'fundacao': time.fundacao?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'dirigente': {
        'cpf': time.dirigente?.cpf ?? '',
        'cargo': time.dirigente?.cargo ?? '',
      },
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> removerJogador(int idTime, String cpfJogador) async {
    final url = Uri.parse('$urlBase/time/remover-jogador');

    final body = {
      'timeId': idTime,
      'jogadorCpf': cpfJogador,
    };

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    return response.statusCode == 200 || response.statusCode == 204;
  }
}
