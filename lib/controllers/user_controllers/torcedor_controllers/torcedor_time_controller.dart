import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';

class TorcedorTimeController {
  List<Time> todosTimes = [];

  Future<void> carregarTimes() async {
    final url = Uri.parse('http://167.234.248.188:8080/v1/time/listar-time-jogadores');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      todosTimes = jsonList.map((json) => Time.fromJson(json)).toList();
    } else {
      throw Exception('Erro ao buscar times');
    }
  }
}
