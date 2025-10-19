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
  bool carregando = true;

  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _conteudo = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarNoticias();
  }

  Future<void> _carregarNoticias() async {
    if (widget.time.idTime != null) {
      await widget.controller.buscarNoticias(widget.time.idTime!);
    }
    setState(() => carregando = false);
  }

  @override
  void dispose() {
    _titulo.dispose();
    _conteudo.dispose();
    super.dispose();
  }

  Future<void> _criarNoticia() async {
    final titulo = _titulo.text.trim();
    final conteudo = _conteudo.text.trim();
    if (titulo.isEmpty || conteudo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    final sucesso = await widget.controller.criarNoticia(
      widget.time.idTime!,
      titulo,
      conteudo,
    );

    if (sucesso) {
      _titulo.clear();
      _conteudo.clear();
      criandoNoticia = false;
      await _carregarNoticias();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao publicar notícia")),
      );
    }
  }

  void _cancelarCriacao() {
    setState(() {
      criandoNoticia = false;
      _titulo.clear();
      _conteudo.clear();
    });
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  if (criandoNoticia) {
                    _cancelarCriacao();
                  } else {
                    criandoNoticia = true;
                  }
                });
              },
              icon: Icon(criandoNoticia ? Icons.close : Icons.add),
              label: Text(criandoNoticia ? "Cancelar" : "Nova notícia"),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                criandoNoticia ? Colors.grey[400] : const Color(0xFF122E6C),
                foregroundColor:
                criandoNoticia ? Colors.black : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (criandoNoticia)
            Column(
              children: [
                TextField(
                  controller: _titulo,
                  decoration: InputDecoration(
                    hintText: "Título da notícia...",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _titulo.clear();
                        setState(() {});
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _conteudo,
                  decoration: InputDecoration(
                    hintText: "Conteúdo da notícia...",
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _conteudo.clear();
                        setState(() {});
                      },
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _criarNoticia,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF122E6C),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Postar"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          if (noticias.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text("Nenhuma notícia publicada."),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                        Text(
                          noticia.titulo ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          noticia.dataPublicacao != null
                              ? formatarDataHora(noticia.dataPublicacao!)
                              : "",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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
