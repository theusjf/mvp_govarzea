import 'package:flutter/material.dart';
import '../../../models/usuarios.dart';
import 'dart:io';
import '../../../models/posts.dart';
import 'package:image_picker/image_picker.dart';

class Criar extends StatefulWidget {
  final Usuario usuario;
  const Criar({super.key, required this.usuario});

  @override
  State<Criar> createState() => _CriarState();
}

class _CriarState extends State<Criar> {
  final _textoController = TextEditingController();
  final imagePicker = ImagePicker();
  File? imagemPost;

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imagemPost = File(pickedFile.path);
      });
    }
  }

  void _criarPost() {
    if (_textoController.text.isEmpty && imagemPost == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira um conteúdo na postagem')),
      );
      return;
    }
    final novoPost = Post(
      usuario: widget.usuario,
      tempo: DateTime.now(),
      texto: _textoController.text.isNotEmpty ? _textoController.text : null,
      imagem: imagemPost,
    );
    setState(() {
      posts.insert(0, novoPost);
    });

    _textoController.clear();
    setState(() {
      imagemPost = null;
    });
  }

  @override
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
                controller: _textoController,
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
                                    pick(ImageSource.gallery);
                                    Navigator.pop(context);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Tirar uma foto'),
                                  onTap: () {
                                    pick(ImageSource.camera);
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
