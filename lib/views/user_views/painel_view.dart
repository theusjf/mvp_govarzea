import 'package:flutter/material.dart';
import '/models/pessoa_models.dart';
import '/models/partida_model.dart';
import '/controllers/painel_controller.dart';
import 'dirigente_views/criar_partida_view.dart';

class PainelView extends StatefulWidget {
  final Pessoa usuario;
  const PainelView({super.key, required this.usuario});

  @override
  State<PainelView> createState() => _PainelViewState();
}

class _PainelViewState extends State<PainelView> {
  final PainelController controller = PainelController();

  late List<Partida> futurasPartidas;

  @override
  void initState() {
    super.initState();
    futurasPartidas = controller.searchPartidas();
  }

  void atualizarPartidas() {
    setState(() {
      futurasPartidas = controller.searchPartidas();
    });
  }

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
            title: const Text('Partidas ao vivo'),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const ListTile(
                    title: Text('Sem partidas ao vivo no momento'),
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
                    title: Text('Nenhum resultado disponível'),
                  ),
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Próximas partidas'),
            children: [
              if (futurasPartidas.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Nenhuma partida cadastrada'),
                )
              else
                ...futurasPartidas.map((partida) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text('${partida.time1.nome} x ${partida.time2.nome}'),
                        subtitle: Text('${partida.local} - ${partida.data}'),
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final novaPartida = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CriarPartidaView(usuario: widget.usuario),
            ),
          );

          if (novaPartida != null) {
            controller.addPartida(novaPartida);
            atualizarPartidas();
          }
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Criar Partida',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }
}
