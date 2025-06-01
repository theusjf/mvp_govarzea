import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mvp_govarzea/models/usuario_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum Funcao { Torcedor, Jogador, Dirigente }

class SignupController {
  final formKey = GlobalKey<FormState>();

  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmController = TextEditingController();
  final cpfController = TextEditingController();
  final telefoneController = TextEditingController();

  DateTime? dataNasc;
  Funcao? funcaoSelecionada;

  Usuario? novoUsuario;

  String? validarNome(String? value) => (value == null || value.isEmpty) ? 'Digite um nome válido' : null;
  String? validarEmail(String? value) => (value == null || value.isEmpty || !EmailValidator.validate(value)) ? 'Digite um e-mail válido' : null;
  String? validarCPF(String? value) => (value == null || value.isEmpty || value.length != 14) ? 'Digite um CPF válido' : null;
  String? validarTelefone(String? value) => (value == null || value.isEmpty) ? 'Digite um telefone válido' : null;
  String? validarDataNasc(DateTime? data) => (data == null) ? 'Por favor, selecione uma data válida' : null;
  String? validarFuncao(Funcao? value) => (value == null) ? 'Selecione uma função válida' : null;
  String? validarSenha(String? value) => (value == null || value.length < 8) ? 'A senha deve ter no mínimo 8 caracteres' : null;
  String? validarConfirmSenha(String? value) => (value != senhaController.text) ? 'As senhas não coincidem' : null;

  Future<bool> criarUsuario(Usuario usuario) async {
    var url = Uri.parse('http://167.234.248.188:8080/contacts');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(usuario.toJson()),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (_) {
      return false;
    }
  }

  Future<bool> registrarUsuario() async {
    if (formKey.currentState?.validate() ?? false) {
      if (dataNasc == null || funcaoSelecionada == null) return false;

      novoUsuario = Usuario(
        id: 0,
        nome: nomeController.text.trim(),
        cpf: cpfController.text.trim(),
        email: emailController.text.trim(),
        senha: senhaController.text,
        telefone: telefoneController.text.trim(),
        dataNasc: dataNasc!,
        foto: null,
      );

      return await criarUsuario(novoUsuario!);
    }
    return false;
  }
}

