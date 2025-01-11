import 'package:flutter/material.dart';
import '../../../models/usuarios.dart';
import '../../../models/times.dart';
import '../../../models/partidas.dart';
import 'marcar_partida.dart';

class Painel extends StatefulWidget {
  final Usuario usuario;

  const Painel({super.key, required this.usuario});

  @override
  _PainelState createState() => _PainelState();
}

class _PainelState extends State<Painel> {
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
            title: const Text('Marcar Partida'),
            onExpansionChanged: (expanded) {
              if (expanded) {
                Future.microtask(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarcarPartidaPage(usuario: widget.usuario),
                    ),
                  );
                });
              }
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text('Placares ao vivo'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    title: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Real Pirituba 1',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Text('X', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 10),
                        Text(
                          '1 Amigos da Varzea',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AO VIVO',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        Text("Horário de início: 13:30"),
                        Text("Local: Rua Ana Rosa, 166 - Perus"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Resultados'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Row(
                      children: [
                        SizedBox(width: 10),
                        Text(
                          'Real Pirituba 3',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10),
                        Text('X', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 10),
                        Text(
                          '2 AliançaFut',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Encerrado: 20/12/2024 às 17:42"),
                        Text("Local: Rua Joaquim Oliveira Freitas, 120 - Pirituba"),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text('Próximas partidas'),
            children: [
              for (var partida in partidas)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10.0),
                      title: Row(
                        children: [
                          const SizedBox(width: 10),
                          Text(
                            partida.time1.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 10),
                          const Text('X', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 10),
                          Text(
                            partida.time2.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Data: ${partida.data.day}/${partida.data.month}/${partida.data.year}"),
                          Text("Local: ${partida.local}"),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
