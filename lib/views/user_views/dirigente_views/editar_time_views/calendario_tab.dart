import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';
import 'package:intl/intl.dart';

class CalendarioTab extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const CalendarioTab({super.key, required this.time, required this.controller});

  @override
  State<CalendarioTab> createState() => _CalendarioTabState();
}

class _CalendarioTabState extends State<CalendarioTab> {
  bool criandoEvento = false;
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _conteudo = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarEventos();
  }

  Future<void> _carregarEventos() async {
    if (widget.time.idTime != null) {
      await widget.controller.buscarEventos(widget.time.idTime!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _titulo.dispose();
    _conteudo.dispose();
    _dataController.dispose();
    super.dispose();
  }

  String formatarDataHora(DateTime data) {
    return DateFormat('dd/MM/yyyy HH:mm').format(data);
  }

  Future<void> _criarEvento() async {
    final titulo = _titulo.text.trim();
    final conteudo = _conteudo.text.trim();
    final dataText = _dataController.text.trim();

    if (titulo.isEmpty || conteudo.isEmpty || dataText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos")),
      );
      return;
    }

    DateTime? dataEvento;
    try {
      dataEvento = DateFormat('dd/MM/yyyy HH:mm').parseStrict(dataText);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data inválida! Use dd/MM/yyyy HH:mm")),
      );
      return;
    }

    final sucesso = await widget.controller.criarEvento(
      widget.time.idTime!,
      titulo,
      conteudo,
      null,
      dataEvento,
    );

    if (sucesso) {
      _titulo.clear();
      _conteudo.clear();
      _dataController.clear();
      criandoEvento = false;
      await widget.controller.buscarEventos(widget.time.idTime!);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao publicar evento")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: () => setState(() => criandoEvento = !criandoEvento),
              icon: const Icon(Icons.add),
              label: const Text("Novo evento"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF122E6C),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (criandoEvento)
            Column(
              children: [
                TextField(
                  controller: _titulo,
                  decoration: const InputDecoration(
                    hintText: "Título do evento...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _conteudo,
                  decoration: const InputDecoration(
                    hintText: "Descrição do evento...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _dataController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    hintText: "Data e hora (dd/MM/yyyy HH:mm)",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    // Adiciona barra e dois pontos automaticamente
                    if (value.length == 2 || value.length == 5) {
                      _dataController.text = value + '/';
                      _dataController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _dataController.text.length),
                      );
                    } else if (value.length == 10) {
                      _dataController.text = value + ' ';
                      _dataController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _dataController.text.length),
                      );
                    } else if (value.length == 13) {
                      _dataController.text = value + ':';
                      _dataController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _dataController.text.length),
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _criarEvento,
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
            itemCount: widget.controller.eventos.length,
            itemBuilder: (context, index) {
              final evento = widget.controller.eventos[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatarDataHora(evento.data!),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(evento.titulo ?? "",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(evento.conteudo ?? ""),
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
