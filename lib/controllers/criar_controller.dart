import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post_model.dart';
import '../models/usuario_model.dart';

class CriarController {
  final textoController = TextEditingController();
  final imagePicker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Post criarPost(Usuario usuario, File? imagem) {
    return Post(
      usuario: usuario,
      tempo: DateTime.now(),
      texto: textoController.text.isNotEmpty ? textoController.text : null,
      imagem: imagem,
    );
  }

  void dispose() {
    textoController.dispose();
  }
}
