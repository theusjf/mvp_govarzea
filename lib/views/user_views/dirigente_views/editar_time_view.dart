import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '../../../controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';

class EditarTimeView extends StatefulWidget {
  final Time time;

  const EditarTimeView({super.key, required this.time});

  @override
  State<EditarTimeView> createState() => _EditarTimeViewState();
}

class _EditarTimeViewState extends State<EditarTimeView> {
  final EditarTimeController controller = EditarTimeController();

  late TextEditingController nomeController;
  late TextEditingController localizacaoController;
  late TextEditingController fundacaoController;

  @override
  void initState() {
    super.initState();
    nomeController = TextEditingController(text: widget.time.nome);
    localizacaoController = TextEditingController(text: widget.time.localizacao ?? '');
    fundacaoController = TextEditingController(
      text: widget.time.fundacao != null
          ? widget.time.fundacao!.toIso8601String().split('T')[0]
          : '',
    );
  }

  @override
  void dispose() {
    nomeController.dispose();
    localizacaoController.dispose();
    fundacaoController.dispose();
    super.dispose();
  }

  Future<void> salvarEdicao() async {
    final atualizado = Time(
      idTime: widget.time.idTime,
      nome: nomeController.text,
      localizacao: localizacaoController.text,
      fundacao: fundacaoController.text.isNotEmpty
          ? DateTime.tryParse(fundacaoController.text)
          : null,
      jogadores: widget.time.jogadores,
      dirigente: widget.time.dirigente,
    );

    final sucesso = await controller.updateTime(atualizado);

    if (sucesso && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time atualizado com sucesso!')),
      );
      Navigator.pop(context, atualizado);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar o time')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Time')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: 'Nome do Time'),
            ),
            TextField(
              controller: localizacaoController,
              decoration: const InputDecoration(labelText: 'Localização'),
            ),
            TextField(
              controller: fundacaoController,
              decoration: const InputDecoration(labelText: 'Fundação (yyyy-MM-dd)'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvarEdicao,
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
