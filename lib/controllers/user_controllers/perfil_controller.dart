import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '/models/pessoa_models.dart';

class PerfilController {
  final String? foto;
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();

  bool isEditing = false;

  PerfilController(Pessoa usuario)
      : foto = usuario.foto {
    cpfController.text = usuario.cpf;
    nomeController.text = usuario.nome;
    emailController.text = usuario.email;
    telefoneController.text = usuario.telefone;
  }

  Widget campo(String label, TextEditingController controller) {
    return isEditing
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 15),
      ],
    )
        : Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(controller.text)),
        ],
      ),
    );
  }

  Future<bool> atualizarUser() async {
    final url = Uri.parse('http://167.234.248.188:8080/v1/pessoa/${cpfController.text.trim()}');
    try {
      final response = await http.put(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "cpf": cpfController.text.trim(),
          "nome": nomeController.text.trim(),
          "email": emailController.text.trim(),
          "telefone": telefoneController.text.trim(),
          "foto": foto,
        }),
      );
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Erro ao atualizar usuário: $e');
      return false;
    }
  }

  Future<bool> deleteUser() async {
    final url = Uri.parse('http://167.234.248.188:8080/v1/pessoa/${cpfController.text.trim()}');
    try {
      final response = await http.delete(url);
      print('DELETE status: ${response.statusCode}');
      print('DELETE response body: ${response.body}');
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print('Erro ao deletar usuário: $e');
      return false;
    }
  }

}
