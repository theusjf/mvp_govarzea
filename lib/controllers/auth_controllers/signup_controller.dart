import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../models/pessoa_models.dart';

class SignupController {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();

  Pessoa? novoUsuario;

  String? validarNome(String? value) =>
      (value == null || value.isEmpty) ? 'Digite um nome válido' : null;

  String? validarEmail(String? value) =>
      (value == null || !EmailValidator.validate(value))
          ? 'Digite um email válido'
          : null;

  String? validarCPF(String? value) =>
      (value == null || value.length != 11) ? 'CPF inválido' : null;

  String? validarTelefone(String? value) =>
      (value == null || value.isEmpty) ? 'Digite um telefone válido' : null;

  String? validarSenha(String? value) =>
      (value == null || value.length < 8)
          ? 'A senha precisa ter no mínimo 8 caracteres'
          : null;

  String? validarConfirmSenha(String? value) =>
      (value != senhaController.text) ? 'As senhas não coincidem' : null;

  Future<bool> registrarPessoa() async {
    if (!(formKey.currentState?.validate() ?? false)) return false;

    final pessoaData = {
      "cpf": cpfController.text.trim(),
      "nome": nomeController.text.trim(),
      "email": emailController.text.trim(),
      "telefone": telefoneController.text.trim(),
      "senha": senhaController.text.trim(),
    };

    final url = Uri.parse('http://167.234.248.188:8080/v1/pessoa');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pessoaData),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        novoUsuario = Pessoa(
          cpf: cpfController.text.trim(),
          nome: nomeController.text.trim(),
          email: emailController.text.trim(),
          telefone: telefoneController.text.trim(),
          senha: senhaController.text.trim(),
        );
        return true;
      } else {
        print('Erro no registro: ${response.statusCode}');
        print('Resposta do servidor: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Erro inesperado: $e');
      return false;
    }
  }
}
