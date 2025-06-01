import 'package:flutter/material.dart';
import 'package:mvp_govarzea/models/usuario_model.dart';

class ChatView extends StatelessWidget {
  final Usuario usuario;
  const ChatView({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Função ainda indisponível'),),
    );
  }
}
