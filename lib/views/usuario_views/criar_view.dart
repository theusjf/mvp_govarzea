import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/models/post_model.dart';
import '/controllers/criar_controller.dart';
import '/models/usuario_model.dart';

class CriarView extends StatefulWidget {
  final Usuario usuario;
  const CriarView({super.key, required this.usuario});

  @override
  State<CriarView> createState() => _CriarViewState();
}

class _CriarViewState extends State<CriarView> {
  final CriarController _controller = CriarController();
  File? imagemPost;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _pick(ImageSource source) async {
    final img = await _controller.pickImage(source);
    if (img != null) {
      setState(() {
        imagemPost = img;
      });
    }
  }

  void _criarPost() {
    if (_controller.textoController.text.isEmpty && imagemPost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira um conteúdo na postagem')),
      );
      return;
    }

    final post = _controller.criarPost(widget.usuario, imagemPost);

    setState(() {
      posts.insert(0, post);
      imagemPost = null;
      _controller.textoController.clear();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Criar Postagem"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _controller.textoController,
                decoration: const InputDecoration(
                  labelText: "Digite algo...",
                  hintText: "Digite algo...",
                  alignLabelWithHint: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              if (imagemPost != null)
                Image.file(imagemPost!),
              Row(
                children: [
                  InkWell(
                    onTap: () {
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
                                ListTile(
                                  leading: const Icon(Icons.delete),
                                  title: const Text('Remover a foto'),
                                  onTap: () {
                                    setState(() {
                                      imagemPost = null;
                                    });
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      Icons.photo,
                      size: 50,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _criarPost();
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text("Postar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
