import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';
import '/models/pessoa_models.dart';

class EditarTimeController {
  final String urlBase = 'http://167.234.248.188:8080/v1';

  List<Jogador> jogDisponiveis = [];
  List<Jogador> jogSelecionados = [];
  List<Jogador> sugestoes = [];

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
    final body = {
      'timeId': idTime,
      'jogadorCpf': jogador.cpf,
    };

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
    final body = {
      'timeId': idTime,
      'jogadorCpf': jogador.cpf,
    };

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
}
