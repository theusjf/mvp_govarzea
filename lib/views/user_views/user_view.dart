import 'package:flutter/material.dart';
import 'package:mvp_govarzea/models/pessoa_models.dart';
import 'home_view.dart';
import 'criar_post_view.dart';
import 'painel_view.dart';
import 'perfil_view.dart';
import '/controllers/user_controllers/user_views_controller.dart';

class UsuarioView extends StatefulWidget {
  final Pessoa usuario;
  const UsuarioView({super.key, required this.usuario});

  @override
  State<UsuarioView> createState() => _UsuarioViewState();
}

class _UsuarioViewState extends State<UsuarioView> {
  int atualIndex = 0;
  late final UsuarioViewsController controller;

  @override
  void initState() {
    super.initState();
    controller = UsuarioViewsController(usuario: widget.usuario);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: controller.pages[atualIndex],
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
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Painel de Jogos'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Criar'),
          BottomNavigationBarItem(icon: Icon(Icons.shield), label: 'Times'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil')
        ],
      ),
    );
  }
}