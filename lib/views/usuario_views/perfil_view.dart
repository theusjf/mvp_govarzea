import 'dart:io';
import 'package:flutter/material.dart';
import '/views/login_view.dart';
import '/models/usuario_model.dart';
import '../../../controllers/perfil_controller.dart';

class PerfilView extends StatefulWidget {
  final Usuario usuario;

  const PerfilView({super.key, required this.usuario});

  @override
  State<PerfilView> createState() => _PerfilViewState();
}

class _PerfilViewState extends State<PerfilView> {
  late PerfilController controller;

  @override
  void initState() {
    super.initState();
    controller = PerfilController(widget.usuario);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            CircleAvatar(
              radius: 80,
              backgroundColor: Colors.grey,
              child: widget.usuario.foto != null
                  ? ClipOval(
                child: Image.file(
                  File(widget.usuario.foto!.path),
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              )
                  : Icon(
                Icons.person,
                color: Colors.grey[200],
                size: 70,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  controller.campo('Nome', controller.nomeController),
                  controller.campo('Email', controller.emailController),
                  controller.campo('CPF', controller.cpfController, enabled: false),
                  controller.campo('Telefone', controller.telefoneController),
                  controller.campo('Data de Nascimento', controller.dataNascController, enabled: false),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (controller.isEditing) {
                          controller.atualizarUsuario();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Usuário atualizado com sucesso')),
                          );
                        } else {
                          controller.isEditing = true;
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(controller.isEditing ? 'Salvar Alterações' : 'Editar Perfil'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sair'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Erro ao excluir conta')),
                  );
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginView()),
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Excluir conta'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
