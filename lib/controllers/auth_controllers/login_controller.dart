import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/views/user_views/user_view.dart';
import '/models/pessoa_models.dart';
import '../get_tipo_perfil.dart';

class LoginController {
  final String pessoasUrl = 'http://167.234.248.188:8080/v1/pessoa';

  Future<void> fazerLogin(
      BuildContext context,
      String email,
      String senha,
      ) async {
    try {
      final response = await http.get(
        Uri.parse(pessoasUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);

        final userJson = data.firstWhere(
              (u) => u['email'] == email && u['senha'] == senha,
          orElse: () => null,
        );

        if (userJson != null) {
          final usuario = Pessoa.fromJson(userJson);

          // pegar tipo perfil (temporario)
          final getTipoPerfil = GetTipoPerfil(usuario);
          Role? perfil = await getTipoPerfil.fetchTipoPerfil();

          print('Perfil: ${usuario.cpf}: $perfil');

          usuario.tipoPerfil = perfil;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => UsuarioView(usuario: usuario),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Usuário não encontrado')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro no login: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro inesperado: $e')),
      );
    }
  }
}
