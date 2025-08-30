//classe temporaria pra pegar tipo de perfil do usuario e gerenciar as views

import '/models/pessoa_models.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class GetTipoPerfil {
  final Pessoa usuario;

  GetTipoPerfil(this.usuario);

  final String jogadorUrl = 'https://167.234.248.188:8080/v1/jogador';
  final String dirigenteUrl = 'https://167.234.248.188:8080/v1/dirigente';
  final String torcedorUrl = 'https://167.234.248.188:8080/v1/torcedor';

  Future<Role?> fetchTipoPerfil() async {
    try {
      final responseJogador = await http.get(
        Uri.parse('$jogadorUrl/${usuario.cpf}'),
        headers: {'Content-Type': 'application/json'},
      );
      if (responseJogador.statusCode == 200 && responseJogador.body.isNotEmpty) {
        final data = jsonDecode(responseJogador.body);
        if (data != null && data['apelido'] != null && (data['apelido'] as String).isNotEmpty) {
          return Role.ROLE_Jogador;
        }
      }

      final responseDirigente = await http.get(
        Uri.parse('$dirigenteUrl/${usuario.cpf}'),
        headers: {'Content-Type': 'application/json'},
      );
      if (responseDirigente.statusCode == 200 && responseDirigente.body.isNotEmpty) {
        final data = jsonDecode(responseDirigente.body);
        if (data != null && data['cargo'] != null && (data['cargo'] as String).isNotEmpty) {
          return Role.ROLE_Dirigente;
        }
      }

      final responseTorcedor = await http.get(
        Uri.parse('$torcedorUrl/${usuario.cpf}'),
        headers: {'Content-Type': 'application/json'},
      );
      if (responseTorcedor.statusCode == 200 && responseTorcedor.body.isNotEmpty) {
        final data = jsonDecode(responseTorcedor.body);
        if (data != null && data['biografia'] != null && (data['biografia'] as String).isNotEmpty) {
          return Role.ROLE_Torcedor;
        }
      }

      return null;
    } catch (e) {
      print('Erro de busca tipoPerfil: $e');
      return null;
    }
  }
}
