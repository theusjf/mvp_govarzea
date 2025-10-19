import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';

class CalendarioTabInfo extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const CalendarioTabInfo({super.key, required this.time, required this.controller});

  @override
  State<CalendarioTabInfo> createState() => _CalendarioTabInfoState();
}

class _CalendarioTabInfoState extends State<CalendarioTabInfo> {
  bool criandoEvento = false;
  DateTime? _dataEvento;
  final TextEditingController _titulo = TextEditingController();
  final TextEditingController _conteudo = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
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
