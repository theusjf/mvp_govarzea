import 'dart:io';
import 'usuario_model.dart';

class Post {
  final Usuario usuario;
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

//Post de exemplo

void postExemplo() {
  List<Post> postsExemplo = [
    Post(
      usuario: usuario1,
      tempo: DateTime.now(),
      texto: "Sou apaixonado pelo futebol de várzea!",
    ),
    Post(
      usuario: usuario2,
      tempo: DateTime.now(),
      texto: "Bom dia para todos os amantes de futebol!",
    ),
  ];

  posts.addAll(postsExemplo);
}
