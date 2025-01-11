import 'package:flutter/material.dart';
import 'package:mvp_govarzea/models/usuarios.dart';
import 'home/home.dart';
import 'painel/painel.dart';
import 'criar/criar.dart';
import 'chat/chat.dart';
import 'perfil/perfil.dart';

 class HomeView extends StatefulWidget {
   final Usuario usuario;
   const HomeView({super.key, required this.usuario});

  @override
  State<HomeView> createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
   int atualIndex = 0;
   late final Usuario usuario;

   void initState() {
     super.initState();
     usuario = widget.usuario;
   }


   @override
   Widget build(BuildContext context) {

     final List<Widget> _pages = [
       Home(usuario: usuario),
       Painel(usuario: usuario),
       Criar(usuario: usuario),
       Chat(usuario: usuario),
       Perfil(usuario: usuario)
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
             BottomNavigationBarItem(
                 icon: Icon(Icons.home),
                 label: 'Início'
             ),
             BottomNavigationBarItem(
                 icon: Icon(Icons.sports_soccer),
                 label: 'Painel de Jogos'
             ),
             BottomNavigationBarItem(
                 icon: Icon(Icons.add),
                 label: 'Criar',
             ),
             BottomNavigationBarItem(
                 icon: Icon(Icons.chat),
                 label: 'Chat'
             ),
             BottomNavigationBarItem(
                 icon: Icon(Icons.person),
                 label: 'Perfil'
             )
           ]
       ),
     );
   }
}
