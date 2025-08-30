import 'dart:io';
import 'package:flutter/material.dart';
import '../../widgets/appbar_global.dart';
import '/views/auth_views/login_view.dart';
import '/models/pessoa_models.dart';
import '/controllers/user_controllers/perfil_controller.dart';

class PerfilView extends StatefulWidget {
  final Pessoa usuario;

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
      appBar: GlobalAppBar(title: 'Meu Perfil'),
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
                  File(widget.usuario.foto!),
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
                  controller.campo('Cpf', controller.cpfController),
                  controller.campo('Nome', controller.nomeController),
                  controller.campo('Email', controller.emailController),
                  controller.campo('Telefone', controller.telefoneController),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (controller.isEditing) {
                        final sucesso = await controller.atualizarUser();
                        if (sucesso) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Usuário atualizado com sucesso')),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Erro ao atualizar usuário')),
                          );
                        }
                      }
                      setState(() {
                        controller.isEditing = !controller.isEditing;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF122E6C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(controller.isEditing
                        ? 'Salvar Alterações'
                        : 'Editar Perfil'),
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
                onPressed: () async {
                  final sucesso = await controller.deleteUser();
                  if (sucesso) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Conta excluída')),
                    );
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                          (route) => false,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Erro ao excluir a conta')),
                    );
                  }
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
