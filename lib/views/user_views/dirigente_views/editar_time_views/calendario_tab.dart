import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';

class CalendarioTab extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const CalendarioTab({super.key, required this.time, required this.controller});

  @override
  State<CalendarioTab> createState() => _CalendarioTabState();
}

class _CalendarioTabState extends State<CalendarioTab> {
  bool criandoEvento = false;
  DateTime? _dataEvento;
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _conteudo = TextEditingController();

  @override
  void dispose() {
    _titulo.dispose();
    _conteudo.dispose();
    super.dispose();
  }

  String formatarDataHora(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return "$dia/$mes/$ano $hora:$minuto";
  }

  Future<void> _criarEvento() async {
    final titulo = _titulo.text;
    final conteudo = _conteudo.text;
    if (titulo.isEmpty || conteudo.isEmpty || _dataEvento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos e selecione a data")),
      );
      return;
    }

    final sucesso = await widget.controller.criarEvento(
      widget.time.idTime!,
      titulo,
      conteudo,
      null,
      _dataEvento,
    );

    if (sucesso) {
      _titulo.clear();
      _conteudo.clear();
      _dataEvento = null;
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dataEvento != null
                            ? "Data: ${formatarDataHora(_dataEvento!)}"
                            : "Selecionar data",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final dataSelecionada = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2100),
                          locale: const Locale('pt', 'BR'),
                        );
                        if (dataSelecionada != null) {
                          final horaSelecionada = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (horaSelecionada != null) {
                            setState(() {
                              _dataEvento = DateTime(
                                dataSelecionada.year,
                                dataSelecionada.month,
                                dataSelecionada.day,
                                horaSelecionada.hour,
                                horaSelecionada.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
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
