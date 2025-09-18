import 'dart:convert';
import 'package:http/http.dart' as http;
import '/models/time_model.dart';
import '/models/pessoa_models.dart';

class CriarTimeController {
  final String urlBase = 'http://167.234.248.188:8080/v1';

  List<Jogador> jogDisponiveis = [];
  List<Jogador> jogSelecionados = [];
  List<Jogador> sugestoes = [];

  Future<Dirigente?> searchDirigente(String cpf) async {
    final url = Uri.parse('$urlBase/dirigente/$cpf');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return Dirigente.fromJson(jsonDecode(response.body));
    }
    return null;
  }

  Future<List<Jogador>> searchJogador() async {
    final url = Uri.parse('$urlBase/jogador');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Jogador.fromJson(json)).toList();
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
        final pessoaJson = jsonDecode(response.body);
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

  Future<Dirigente?> carregarDados(String cpfDirigente) async {
    final dirigente = await searchDirigente(cpfDirigente);
    jogDisponiveis = await searchJogador();
    jogDisponiveis = await searchNomes(jogDisponiveis);
    return dirigente;
  }

  void filtroSugestoes(String input) {
    final query = input.toLowerCase();
    sugestoes = jogDisponiveis.where((jogador) {
      final nome = jogador.pessoa.nome.toLowerCase();
      final apelido = (jogador.apelido ?? '').toLowerCase();
      return nome.contains(query) || apelido.contains(query);
    }).toList();
  }

  void addJogador(Jogador jogador) {
    if (!jogSelecionados.any((j) => j.cpf == jogador.cpf)) {
      jogSelecionados.add(jogador);
    }
    sugestoes.clear();
  }

  void removerJogador(Jogador jogador) {
    jogSelecionados.removeWhere((j) => j.cpf == jogador.cpf);
  }

  Future<int?> criarTime(Time time) async {
    final url = Uri.parse('$urlBase/time');
    final body = {
      'nome': time.nome,
      'localizacao': time.localizacao ?? 'Local não informado',
      'fundacao': time.fundacao?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'cpfdirigente': time.dirigente!.cpf,
    };

    final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['idTime'];
    }
    return null;
  }

  Future<bool> addJogadores(int idTime, List<Jogador> jogadores) async {
    final url = Uri.parse('$urlBase/time/adicionar-jogador');
    for (final jogador in jogadores) {
      final body = {'timeId': idTime, 'jogadorCpf': jogador.cpf};
      final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
      if (response.statusCode != 200 && response.statusCode != 201) {
        return false;
      }
    }
    return true;
  }
}
