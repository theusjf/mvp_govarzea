import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class JogadorInfoController {
  final String jogadorUrl = "https://167.234.248.188:8080/v1/jogador";
  final String pessoaUrl = "https://167.234.248.188:8080/v1/pessoa";
  final String timeUrl = "https://167.234.248.188:8080/v1/time/listar-time-jogadores";

  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController apelidoController = TextEditingController();
  final TextEditingController posicaoController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController numeroCamisaController = TextEditingController();

  Future<void> carregarJogador(String cpf) async {
    final jogadorRes = await http.get(Uri.parse("$jogadorUrl/$cpf"));
    if (jogadorRes.statusCode == 200) {
      final data = jsonDecode(utf8.decode(jogadorRes.bodyBytes));
      cpfController.text = data["cpf"] ?? "";
      apelidoController.text = data["apelido"] ?? "";
      numeroCamisaController.text = data["numeroCamisa"] ?? "";
    }

    final pessoaRes = await http.get(Uri.parse("$pessoaUrl/$cpf"));
    if (pessoaRes.statusCode == 200) {
      final data = jsonDecode(utf8.decode(pessoaRes.bodyBytes));
      nomeController.text = data["nome"] ?? "";
    }

    final timeRes = await http.get(Uri.parse(timeUrl));
    if (timeRes.statusCode == 200) {
      final data = jsonDecode(utf8.decode(timeRes.bodyBytes));
      for (var time in data) {
        final jogadores = time["jogadores"] as List<dynamic>;
        final jogador = jogadores.firstWhere(
              (j) => j["cpf"] == cpf,
          orElse: () => null,
        );
        if (jogador != null) {
          timeController.text = time["nome"] ?? "";
          break;
        }
      }
    }
    posicaoController.text = "";
  }

  Widget campo(String label, TextEditingController controller) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              controller.text,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
