import 'dart:io';
import 'usuarios.dart';

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
  Usuario usuarioExemplo = Usuario(
    id: 999,
    nome: "Pedro Santos",
    email: "pedro@gmail.com",
    senha: '12345678',
  );

  Usuario usuarioExemplo2 = Usuario(
    id: 1000,
    nome: "Julia Oliveira",
    email: "julia@gmail.com",
    senha: '12345678',
  );

  List<Post> postsExemplo = [
    Post(
      usuario: usuarioExemplo,
      tempo: DateTime.now(),
      texto: "Sou apaixonado pelo futebol de várzea!",
    ),
    Post(
      usuario: usuarioExemplo2,
      tempo: DateTime.now(),
      texto: "Bom dia para todos os amantes de futebol!",
    ),
  ];

  posts.addAll(postsExemplo);
}
