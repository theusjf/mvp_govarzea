import 'package:flutter/material.dart';
import '../../../models/usuarios.dart';
import '../../../models/times.dart';
import '../../../models/partidas.dart';


class MarcarPartidaPage extends StatefulWidget {
  final Usuario usuario;

  const MarcarPartidaPage({super.key, required this.usuario});

  @override
  _MarcarPartidaPageState createState() => _MarcarPartidaPageState();
}

class _MarcarPartidaPageState extends State<MarcarPartidaPage> {
  Time? timeAdversario;
  DateTime dataPartida = DateTime.now();
  String horaPartida = '';
  String localPartida = '';
  FocusNode _focusNodeData = FocusNode();
  FocusNode _focusNodeLocal = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcar Partida'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          widget.usuario.time == null
              ? const Text(
            "Selecione um time para marcar partida",
            style: TextStyle(color: Colors.red),
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text("Seu time: ${widget.usuario.time?.nome}"),
              ),
              DropdownButton<Time>(
                hint: const Text('Escolha um time adversário'),
                value: timeAdversario,
                onChanged: (Time? novoTime) {
                  setState(() {
                    timeAdversario = novoTime;
                  });
                },
                items: times
                    .where((time) => time != widget.usuario.time)
                    .map((time) {
                  return DropdownMenuItem<Time>(
                    value: time,
                    child: Text(time.nome),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
              TextField(
                focusNode: _focusNodeData,
                decoration: InputDecoration(
                  labelText: 'Data e Hora da Partida',
                  hintText: '${dataPartida.day}/${dataPartida.month}/${dataPartida.year} - $horaPartida',
                ),
                onTap: () async {
                  _focusNodeData.unfocus();
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: dataPartida,
                    firstDate: DateTime(2025),
                    lastDate: DateTime(2050),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      dataPartida = pickedDate;
                    });
                  }
                  final TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      horaPartida = pickedTime.format(context);
                    });
                  }
                },
                controller: TextEditingController(
                  text: '${dataPartida.day}/${dataPartida.month}/${dataPartida.year} - $horaPartida',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                focusNode: _focusNodeLocal,
                decoration: const InputDecoration(
                  labelText: 'Local da Partida',
                  hintText: 'Informe o local',
                ),
                onChanged: (value) {
                  setState(() {
                    localPartida = value;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: timeAdversario == null || localPartida.isEmpty
                    ? null
                    : () {
                  final partida = Partida(
                    time1: widget.usuario.time!,
                    time2: timeAdversario!,
                    data: dataPartida,
                    local: localPartida,
                  );
                  setState(() {
                    partidas.add(partida);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Partida marcada')),
                  );
                  Navigator.pop(context);
                },
                child: const Text('Marcar Partida'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
