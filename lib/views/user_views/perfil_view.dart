import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String? fotoUrl;

  @override
  void initState() {
    super.initState();
    controller = PerfilController(widget.usuario);
    _loadFoto();
  }

  Future<void> _loadFoto() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedFoto = prefs.getString('usuario_${widget.usuario.cpf}_foto');
    if (cachedFoto != null) {
      setState(() => fotoUrl = cachedFoto);
    } else {
      final url = await controller.buscarFoto(widget.usuario.cpf);
      if (url != null) {
        setState(() => fotoUrl = url);
        await prefs.setString('usuario_${widget.usuario.cpf}_foto', url);
      }
    }
  }

  Future<void> _pick(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final novaUrl = await controller.uploadFoto(widget.usuario.cpf, file);
      if (novaUrl != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuario_${widget.usuario.cpf}_foto', novaUrl);
        setState(() {
          fotoUrl = "$novaUrl?${DateTime.now().millisecondsSinceEpoch}";
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto atualizada com sucesso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar foto')),
        );
      }
    }
  }

  void _showModalFotos() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Selecionar uma foto na galeria'),
                onTap: () {
                  _pick(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Tirar uma foto'),
                onTap: () {
                  _pick(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(title: 'Meu Perfil'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Stack(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors.grey,
                  backgroundImage: fotoUrl != null ? NetworkImage(fotoUrl!) : null,
                  child: fotoUrl == null
                      ? Icon(Icons.person, size: 70, color: Colors.grey[200])
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showModalFotos,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.edit, size: 30, color: Colors.grey[700]),
                    ),
                  ),
                ),
              ],
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
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              sucesso ? 'Usuário atualizado com sucesso' : 'Erro ao atualizar usuário',
                            ),
                          ),
                        );
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
                    child: Text(controller.isEditing ? 'Salvar Alterações' : 'Editar Perfil'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  if (mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                          (route) => false,
                    );
                  }
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
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(sucesso ? 'Conta excluída' : 'Erro ao excluir a conta'),
                    ),
                  );
                  if (sucesso) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginView()),
                          (route) => false,
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
