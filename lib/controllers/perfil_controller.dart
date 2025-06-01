import 'package:flutter/material.dart';
import '/models/usuario_model.dart';

class PerfilController {
  Usuario usuario;

  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController telefoneController = TextEditingController();
  final TextEditingController dataNascController = TextEditingController();

  bool isEditing = false;

  PerfilController(this.usuario) {
    nomeController.text = usuario.nome;
    emailController.text = usuario.email;
    cpfController.text = usuario.cpf;
    telefoneController.text = usuario.telefone;
    dataNascController.text = usuario.dataNasc.toIso8601String().split('T').first;
  }

  Widget campo(String label, TextEditingController controller, {bool enabled = true}) {
    return isEditing
        ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          enabled: enabled,
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

  void atualizarUsuario() {
    usuario = Usuario(
      id: usuario.id,
      nome: nomeController.text,
      cpf: usuario.cpf,
      email: emailController.text,
      senha: usuario.senha,
      telefone: telefoneController.text,
      dataNasc: usuario.dataNasc,
      foto: usuario.foto,
    );
    isEditing = false;
  }
}
