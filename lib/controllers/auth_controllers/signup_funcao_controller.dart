import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/pessoa_models.dart';

class SignupFuncaoController {
  Role? funcaoSelecionada;

  final formKey = GlobalKey<FormState>();

  final apelidoController = TextEditingController();
  final numeroCamisaController = TextEditingController();
  final cargoController = TextEditingController();
  final biografiaController = TextEditingController();

  String? validarCampo(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }

  Future<bool> registrarFuncao(Pessoa usuario) async {
    if (funcaoSelecionada == null) {
      return false;
    }

    String url = '';
    Map<String, dynamic> body = {"cpf": usuario.cpf};

    if (funcaoSelecionada == Role.ROLE_Jogador) {
      url = 'https://167.234.248.188:8080/v1/jogador';

      if (apelidoController.text.trim().isEmpty ||
          numeroCamisaController.text.trim().isEmpty) {
        return false;
      }

      body['apelido'] = apelidoController.text.trim();
      body['numeroCamisa'] = numeroCamisaController.text.trim();

    } else if (funcaoSelecionada == Role.ROLE_Dirigente) {
      url = 'https://167.234.248.188:8080/v1/dirigente';

      if (cargoController.text.trim().isEmpty) {
        return false;
      }

      body['cargo'] = cargoController.text.trim();

    } else if (funcaoSelecionada == Role.ROLE_Torcedor) {
      url = 'https://167.234.248.188:8080/v1/torcedor';

      if (biografiaController.text.trim().isEmpty) {
        return false;
      }

      body['biografia'] = biografiaController.text.trim();
    }

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        usuario.tipoPerfil = funcaoSelecionada!;
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
