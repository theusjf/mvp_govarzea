import 'package:flutter/material.dart';
import '/models/usuario_model.dart';
import '/models/time_model.dart';
import '/models/partida_model.dart';

class PainelView extends StatefulWidget {
  final Usuario usuario;
  const PainelView({super.key, required this.usuario});

  @override
  State<PainelView> createState() => _PainelViewState();
}

class _PainelViewState extends State<PainelView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Jogos'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        children: [
          ExpansionTile(
            title: const Text('Placares ao vivo'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Resultados'),
          ),

          ExpansionTile(
            title: const Text('Próximas partidas'),
          ),
        ],
      ),
    );
  }
}
