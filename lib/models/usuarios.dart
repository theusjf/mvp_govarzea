import 'dart:io';
import 'times.dart';

class Usuario {
  final int id;
  final String nome;
  final String email;
  final String senha;
  File? foto;
  Time? time;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.senha,
    this.foto,
    this.time,
  });
}

final List<Usuario> usuarios = [];


