import 'package:flutter/material.dart';
import '../../../widgets/appbar_global.dart';
import '/controllers/user_controllers/dirigente_controllers/criar_partida_controller.dart';
import '/models/partida_model.dart';
import '/models/time_model.dart';
import '/models/pessoa_models.dart';

class CriarPartidaView extends StatefulWidget {
  final Pessoa usuario;
  const CriarPartidaView({super.key, required this.usuario});

  @override
  State<CriarPartidaView> createState() => _CriarPartidaViewState();
}

class _CriarPartidaViewState extends State<CriarPartidaView> {
  final CriarPartidaController controller = CriarPartidaController();
  final TextEditingController localController = TextEditingController();
  final TextEditingController dataController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    localController.dispose();
    dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(title: 'Criar Partida'),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<Time>(
                value: controller.time1,
                hint: const Text('Selecione o Time 1'),
                items: times.map((time) {
                  return DropdownMenuItem(value: time, child: Text(time.nome));
                }).toList(),
                onChanged: (time) => setState(() => controller.time1 = time),
                validator: (value) => value == null ? 'Selecione o Time 1' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<Time>(
                value: controller.time2,
                hint: const Text('Selecione o Time 2'),
                items: times.map((time) {
                  return DropdownMenuItem(value: time, child: Text(time.nome));
                }).toList(),
                onChanged: (time) => setState(() => controller.time2 = time),
                validator: (value) => value == null ? 'Selecione o Time 2' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: localController,
                decoration: const InputDecoration(labelText: 'Local da partida'),
                onChanged: (value) => controller.local = value,
                validator: (value) =>
                value == null || value.isEmpty ? 'Informe o local' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: dataController,
                decoration: const InputDecoration(labelText: 'Data (dd/mm/yyyy)'),
                keyboardType: TextInputType.datetime,
                onChanged: (value) => controller.data = value,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe a data';
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final partida = controller.criarPartida();
                    if (partida != null) {
                      Navigator.pop(context, partida);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Preencha todos os campos corretamente')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF122E6C),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Criar Partida'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
