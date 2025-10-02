import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/views/user_views/user_view.dart';
import '/models/pessoa_models.dart';
import '../get_tipo_perfil.dart';

class LoginController {
  final String authUrl = 'http://167.234.248.188:8080/auth';
  final String pessoaUrl = 'http://167.234.248.188:8080/v1/pessoa';
  final String jogadorUrl = 'http://167.234.248.188:8080/v1/jogador';
  final String dirigenteUrl = 'http://167.234.248.188:8080/v1/dirigente';
  final String torcedorUrl = 'http://167.234.248.188:8080/v1/torcedor';

  Future<void> fazerLogin(
      BuildContext context,
      String email,
      String senha,
      ) async {
    try {
      final pessoasResponse = await http.get(
        Uri.parse(pessoaUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (pessoasResponse.statusCode != 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no servidor: ${pessoasResponse.statusCode}')),
        );
        return;
      }

      final lista = json.decode(utf8.decode(pessoasResponse.bodyBytes)) as List;

      final userJson = lista.cast<Map<String, dynamic>>().firstWhere(
            (u) => u['email'] == email,
        orElse: () => {},
      );

      if (userJson.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Usuário não encontrado')),
        );
        return;
      }

      final cpf = userJson['cpf'];
      String? tipoPerfil;

      final jogadorResponse = await http.get(Uri.parse('$jogadorUrl/$cpf'));

      if (jogadorResponse.statusCode == 200 && jogadorResponse.body.isNotEmpty) {
        tipoPerfil = 'ROLE_JOGADOR';
      }

      final dirigenteResponse = await http.get(Uri.parse('$dirigenteUrl/$cpf'));

      if (dirigenteResponse.statusCode == 200 && dirigenteResponse.body.isNotEmpty) {
        tipoPerfil = 'ROLE_DIRIGENTE';
      }

      final torcedorResponse = await http.get(Uri.parse('$torcedorUrl/$cpf'));

      if (torcedorResponse.statusCode == 200 && torcedorResponse.body.isNotEmpty) {
        tipoPerfil = 'ROLE_TORCEDOR';
      }

      final body = {
        'email': email,
        'password': senha,
        'tipoPerfil': tipoPerfil,
      };


      final response = await http.post(
        Uri.parse(authUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final usuario = Pessoa.fromJson(userJson);
        usuario.tipoPerfil = Role.values.firstWhere(
              (r) => r.toString().split('.').last == tipoPerfil,
          orElse: () => Role.ROLE_Torcedor,
        );

        // pegar tipo perfil (temporário)
        final getTipoPerfil = GetTipoPerfil(usuario);
        Role? perfil = await getTipoPerfil.fetchTipoPerfil();

        usuario.tipoPerfil = perfil;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UsuarioView(usuario: usuario),
          ),
        );
      } else if (response.statusCode == 401 || response.statusCode == 500) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciais inválidas')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no login: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print("❌ Erro inesperado: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
  }

}
