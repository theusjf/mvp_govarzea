import 'package:flutter/material.dart';
import '../../../widgets/appbar_global.dart';
import '/models/pessoa_models.dart';
import '/models/time_model.dart';
import '../../../controllers/user_controllers/jogador_controllers/jogador_time_controller.dart';

class JogadorTimeView extends StatefulWidget {
  final Pessoa usuario;
  const JogadorTimeView({super.key, required this.usuario});

  @override
  State<JogadorTimeView> createState() => _JogadorTimeViewState();
}

class _JogadorTimeViewState extends State<JogadorTimeView> {
  final JogadorTimeController controller = JogadorTimeController();
  Time? time;

  @override
  void initState() {
    super.initState();
    carregarTime();
  }

  @override
  Widget build(BuildContext context) {
    if (time == null) {
      return const Scaffold(
          appBar: GlobalAppBar(title: 'Meu Time'),
        body: Center(child: Text('Você não está em nenhum time')),
      );
    }

    return Scaffold(
      appBar: GlobalAppBar(title: 'Meu Time'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              time!.nome,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Localização: ${time!.localizacao ?? "Não informado"}'),
            Text(
              'Fundação: ${time!.fundacao != null ? time!.fundacao!.toIso8601String().split('T')[0] : "Não informado"}',
            ),
            const SizedBox(height: 20),
            const Text(
              'Jogadores do time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: (time!.jogadores != null && time!.jogadores!.isNotEmpty)
                  ? ListView.builder(
                itemCount: time!.jogadores!.length,
                itemBuilder: (context, index) {
                  final jogador = time!.jogadores![index];
                  return ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(jogador.pessoa.nome),
                    subtitle: Text(
                      'Apelido: ${jogador.apelido ?? "-"} | CPF: ${jogador.cpf}',
                    ),
                  );
                },
              )
                  : const Text('Nenhum jogador no time'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: sairDoTime,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('Sair do Time'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> carregarTime() async {
    final timeEncontrado = await controller.searchJogadorTime(widget.usuario.cpf);
    setState(() {
      time = timeEncontrado;
    });
  }

  Future<void> sairDoTime() async {
    if (time == null) return;

    final sucesso = await controller.exitTime(time!.idTime!, widget.usuario.cpf);

    if (sucesso) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você saiu do time com sucesso')),
        );
        setState(() {
          time = null;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao sair do time')),
        );
      }
    }
  }
}
