import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';
import '/models/noticia_model.dart';
import '/models/evento_model.dart';

class TimeController {
  final Time time;
  final String urlMural = 'http://167.234.248.188:8083/v1/mural';
  final String urlEvento = 'http://167.234.248.188:8083/v1/evento';

  List<Noticia> noticias = [];
  List<Evento> eventos = [];

  TimeController(this.time);

  Future<String?> buscarFoto() async {
    if (time.idTime == null) return null;

    final url = 'http://152.70.216.121:8089/v1/time/${time.idTime}/foto/url';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return response.body;
      }
    } catch (_) {}
    return null;
  }

  Future<void> buscarNoticias() async {
    final response = await http.get(Uri.parse(urlMural));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      noticias = data.map((json) => Noticia.fromJson(json))
          .where((n) => n.idTime == time.idTime)
          .toList();
    }
  }

  Future<void> buscarEventos() async {
    final response = await http.get(Uri.parse(urlEvento));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      eventos = data.map((json) => Evento.fromJson(json))
          .where((e) => e.timeId == time.idTime)
          .toList();
    }
  }

  Future<bool> criarNoticia(String titulo, String conteudo) async {
    final body = jsonEncode({
      'titulo': titulo,
      'conteudo': conteudo,
      'idTime': time.idTime,
    });

    final response = await http.post(
      Uri.parse(urlMural),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<bool> criarEvento(String titulo, String conteudo, String? foto, DateTime? data) async {
    final body = jsonEncode({
      'titulo': titulo,
      'conteudo': conteudo,
      'timeId': time.idTime,
      'foto': foto ?? '',
      'data': data?.toIso8601String() ?? '',
    });

    final response = await http.post(
      Uri.parse(urlEvento),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
