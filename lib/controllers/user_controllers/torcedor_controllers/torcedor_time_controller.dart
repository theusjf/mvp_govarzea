import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';

class TorcedorTimeController {
  List<Time> todosTimes = [];

  final String urlBase = 'http://167.234.248.188:8080/v1';
  final String urlFoto = 'http://152.70.216.121:8089/v1/time';

  Future<void> carregarTimes() async {
    final url = Uri.parse('$urlBase/time/listar-time-jogadores');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(utf8.decode(response.bodyBytes));
      todosTimes = jsonList.map((json) => Time.fromJson(json)).toList();

      for (var time in todosTimes) {
        final foto = await buscarFoto(time.idTime!);
        time.fotoPath = foto;
      }
    } else {
      throw Exception('Erro ao buscar times');
    }
  }

  Future<String?> buscarFoto(int idTime) async {
    final url = Uri.parse('$urlFoto/$idTime/foto/url');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response.body;
      }
    } catch (_) {}
    return null;
  }
}

