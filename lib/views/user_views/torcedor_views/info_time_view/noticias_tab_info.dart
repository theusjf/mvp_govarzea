import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';

class NoticiasTabInfo extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const NoticiasTabInfo({super.key, required this.time, required this.controller});

  @override
  State<NoticiasTabInfo> createState() => _NoticiasTabInfoState();
}

class _NoticiasTabInfoState extends State<NoticiasTabInfo> {
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    if (widget.time.idTime != null) {
      await widget.controller.buscarNoticias(widget.time.idTime!);
      setState(() {
        carregando = false;
      });
    }
  }

  String formatarDataHora(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return "$dia/$mes/$ano $hora:$minuto";
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    final noticias = widget.controller.noticias;

    if (noticias.isEmpty) {
      return const Center(child: Text("Nenhuma notícia publicada."));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: noticias.length,
      itemBuilder: (context, index) {
        final noticia = noticias[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(noticia.titulo ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  noticia.dataPublicacao != null
                      ? formatarDataHora(noticia.dataPublicacao!)
                      : "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(noticia.conteudo ?? ""),
              ],
            ),
          ),
        );
      },
    );
  }
}
