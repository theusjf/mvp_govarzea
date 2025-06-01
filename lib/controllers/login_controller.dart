import 'package:flutter/material.dart';
import '/models/usuario_model.dart';
import '/views/usuario_views/usuario_view.dart';

class LoginController {
  final List<Usuario> usuarios = [usuario1, usuario2, usuario3];

  Future<void> fazerLogin(BuildContext context, String emailUser, String senhaUser) async {
    if (emailUser.isEmpty || senhaUser.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos')),
      );
      return;
    }

    Usuario? userEncontrado;

    try {
      userEncontrado = usuarios.firstWhere(
            (u) => u.email == emailUser && u.senha == senhaUser,
      );
    } catch (e) {
      userEncontrado = null;
    }

    if (userEncontrado != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => UsuarioView(usuario: userEncontrado!),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário ou senha inválidos')),
      );
    }
  }
}
