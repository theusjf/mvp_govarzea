import 'dart:io';
import 'pessoa_models.dart';

class Post {
  final Pessoa usuario;
  final DateTime tempo;
  final String? texto;
  final File? imagem;

  Post({
    required this.usuario,
    required this.tempo,
    this.texto,
    this.imagem,

  });
}

final List<Post> posts = [];




