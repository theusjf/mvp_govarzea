import 'package:flutter/material.dart';
import 'package:mvp_govarzea/models/usuario_model.dart';
import 'home_view.dart';
import 'chat_view.dart';
import 'criar_view.dart';
import 'painel_view.dart';
import 'perfil_view.dart';

class UsuarioView extends StatefulWidget {
  final Usuario usuario;
  const UsuarioView({super.key, required this.usuario});

  @override
  State<UsuarioView> createState() => _UserViewState();
}

class _UserViewState extends State<UsuarioView> {
  int atualIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeView(usuario: widget.usuario),
      PainelView(usuario: widget.usuario),
      CriarView(usuario: widget.usuario),
      ChatView(usuario: widget.usuario),
      PerfilView(usuario: widget.usuario)
    ];

    return Scaffold(
      body: _pages[atualIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        onTap: (index) {
          setState(() {
            atualIndex = index;
          });
        },
        currentIndex: atualIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Painel de Jogos'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Criar'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
