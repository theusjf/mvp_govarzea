import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';

class NoticiasTab extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const NoticiasTab({super.key, required this.time, required this.controller});

  @override
  State<NoticiasTab> createState() => _NoticiasTabState();
}

class _NoticiasTabState extends State<NoticiasTab> {
  bool criandoNoticia = false;
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _conteudo = TextEditingController();

  @override
  void dispose() {
    _titulo.dispose();
    _conteudo.dispose();
    super.dispose();
  }

  Future<void> _criarNoticia() async {
    final titulo = _titulo.text;
    final conteudo = _conteudo.text;
    if (titulo.isEmpty || conteudo.isEmpty) return;

    final sucesso = await widget.controller.criarNoticia(
      widget.time.idTime!,
      titulo,
      conteudo,
    );

    if (sucesso) {
      _titulo.clear();
      _conteudo.clear();
      criandoNoticia = false;
      await widget.controller.buscarNoticias(widget.time.idTime!);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao publicar notícia")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: () => setState(() => criandoNoticia = !criandoNoticia),
              icon: const Icon(Icons.add),
              label: const Text("Nova notícia"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF122E6C),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (criandoNoticia)
            Column(
              children: [
                TextField(
                  controller: _titulo,
                  decoration: const InputDecoration(
                    hintText: "Título da notícia...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _conteudo,
                  decoration: const InputDecoration(
                    hintText: "Conteúdo da notícia...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _criarNoticia,
                  child: const Text("Postar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF122E6C),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.controller.noticias.length,
            itemBuilder: (context, index) {
              final noticia = widget.controller.noticias[index];
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
                            ? "${noticia.dataPublicacao!.day}/${noticia.dataPublicacao!.month}/${noticia.dataPublicacao!.year} ${noticia.dataPublicacao!.hour}:${noticia.dataPublicacao!.minute}"
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
          ),
        ],
      ),
    );
  }
}
