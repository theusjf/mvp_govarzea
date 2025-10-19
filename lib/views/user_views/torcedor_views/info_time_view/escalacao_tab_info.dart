import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';
import '/views/jogador_info_view.dart';

class EscalacaoTabInfo extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const EscalacaoTabInfo({super.key, required this.time, required this.controller});

  @override
  State<EscalacaoTabInfo> createState() => _EscalacaoTabInfoState();
}

class _EscalacaoTabInfoState extends State<EscalacaoTabInfo> {
  @override
  Widget build(BuildContext context) {
    final jogadores = widget.time.jogadores ?? [];

    return Expanded(
      child: jogadores.isEmpty
          ? const Center(child: Text("Nenhum jogador cadastrado."))
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: jogadores.length,
        itemBuilder: (context, index) {
          final jogador = jogadores[index];
          return Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JogadorInfoView(cpf: jogador.cpf),
                      ),
                    );
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.person, size: 50, color: Colors.grey),
                        const SizedBox(height: 10),
                        Text(
                          jogador.apelido ?? jogador.pessoa.nome,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Camisa: ${jogador.numeroCamisa ?? "-"}",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () async {
                      final sucesso = await widget.controller.removerJogador(
                          widget.time.idTime!, jogador);
                      if (sucesso) {
                        setState(() {
                          widget.time.jogadores
                              ?.removeWhere((j) => j.cpf == jogador.cpf);
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
