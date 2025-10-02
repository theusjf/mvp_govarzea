import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';
import '/models/pessoa_models.dart';
import '/models/noticia_model.dart';
import '/models/evento_model.dart';
import 'dart:io';

class EditarTimeController {
  final String urlBase = 'http://167.234.248.188:8080/v1';
  final String urlMural = 'http://167.234.248.188:8083/v1/mural';
  final String urlEvento = 'http://167.234.248.188:8083/v1/evento';

  List<Jogador> jogDisponiveis = [];
  List<Jogador> jogSelecionados = [];
  List<Jogador> sugestoes = [];
  List<Noticia> noticias = [];
  List<Evento> eventos = [];

  Future<List<Jogador>> searchJogadores() async {
    final url = Uri.parse('$urlBase/jogador');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
      final jogadores = data.map((json) => Jogador.fromJson(json)).toList();

      jogDisponiveis = await searchNomes(jogadores);
      return jogDisponiveis;
    }
    return [];
  }

  Future<List<Jogador>> searchNomes(List<Jogador> jogadores) async {
    final respostas = await Future.wait(jogadores.map((jogador) async {
      final response = await http.get(
        Uri.parse('$urlBase/pessoa/${jogador.cpf}'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final pessoaJson = jsonDecode(utf8.decode(response.bodyBytes));
        return Jogador(
          cpf: jogador.cpf,
          apelido: jogador.apelido,
          numeroCamisa: jogador.numeroCamisa,
          pessoa: Pessoa.fromJson(pessoaJson),
        );
      }
      return jogador;
    }));
    return respostas;
  }

  void filtroSugestoes(String input, List<Jogador> jogadoresDoTime) {
    final query = input.toLowerCase();

    sugestoes = jogDisponiveis.where((jogador) {
      final nome = jogador.pessoa.nome.toLowerCase();
      final apelido = (jogador.apelido ?? '').toLowerCase();
      final escalado = jogadoresDoTime.any((j) => j.cpf == jogador.cpf);

      return !escalado && (nome.contains(query) || apelido.contains(query));
    }).toList();
  }

  Future<bool> adicionarJogador(int idTime, Jogador jogador) async {
    final url = Uri.parse('$urlBase/time/adicionar-jogador');
    final body = {'timeId': idTime, 'jogadorCpf': jogador.cpf};

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      jogSelecionados.add(jogador);
      sugestoes.clear();
      return true;
    }
    return false;
  }

  Future<bool> removerJogador(int idTime, Jogador jogador) async {
    final url = Uri.parse('$urlBase/time/remover-jogador');
    final body = {'timeId': idTime, 'jogadorCpf': jogador.cpf};

    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      jogSelecionados.removeWhere((j) => j.cpf == jogador.cpf);
      return true;
    }
    return false;
  }

  Future<String?> uploadFotoTime(int idTime, File arquivo) async {
    final url = Uri.parse('http://152.70.216.121:8089/v1/time/$idTime/upload');
    var request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('file', arquivo.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final resp = await response.stream.bytesToString();
      return resp;
    } else {
      return null;
    }
  }

  Future<void> buscarNoticias(int idTime) async {
    final response = await http.get(Uri.parse(urlMural));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      noticias = data.map((json) => Noticia.fromJson(json))
          .where((n) => n.idTime == idTime)
          .toList();
    }
  }

  Future<bool> criarNoticia(int idTime, String titulo, String conteudo) async {
    final body = jsonEncode({
      'titulo': titulo,
      'conteudo': conteudo,
      'idTime': idTime,
    });

    final response = await http.post(
      Uri.parse(urlMural),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<void> buscarEventos(int idTime) async {
    final response = await http.get(Uri.parse(urlEvento));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      eventos = data.map((json) => Evento.fromJson(json))
          .where((e) => e.timeId == idTime)
          .toList();
    }
  }

  Future<bool> criarEvento(int idTime, String titulo, String conteudo, String? foto, DateTime? data) async {
    final body = jsonEncode({
      'titulo': titulo,
      'conteudo': conteudo,
      'timeId': idTime,
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
