import 'package:flutter/material.dart';
import '../../../models/usuarios.dart';

class Chat extends StatelessWidget {
  final Usuario usuario;
  const Chat({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Função ainda indisponível'),),
    );
  }
}
