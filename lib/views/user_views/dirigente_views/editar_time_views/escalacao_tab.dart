import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';
import '/views/jogador_info_view.dart';
import '/widgets/custom_text_field.dart';

class EscalacaoTab extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const EscalacaoTab({super.key, required this.time, required this.controller});

  @override
  State<EscalacaoTab> createState() => _EscalacaoTabState();
}

class _EscalacaoTabState extends State<EscalacaoTab> {
  @override
  Widget build(BuildContext context) {
    final jogadores = widget.time.jogadores ?? [];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: CustomTextField(
            labelText: 'Pesquisar jogador',
            hintText: 'Digite o nome do jogador',
            onChanged: (value) {
              if (value.isEmpty) {
                widget.controller.sugestoes.clear();
              } else {
                widget.controller.filtroSugestoes(value, widget.time.jogadores ?? []);
              }
              setState(() {});
            },
            icon: const Icon(Icons.search),
          ),
        ),
        if (widget.controller.sugestoes.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: widget.controller.sugestoes.length,
              itemBuilder: (context, index) {
                final jogador = widget.controller.sugestoes[index];
                return ListTile(
                  title: Text('${jogador.pessoa.nome} (${jogador.apelido ?? "-"})'),
                  onTap: () async {
                    final sucesso = await widget.controller.adicionarJogador(
                      widget.time.idTime!,
                      jogador,
                    );
                    if (sucesso) {
                      setState(() {
                        widget.time.jogadores?.add(jogador);
                        widget.controller.sugestoes.clear();
                      });
                    }
                  },
                );
              },
            ),
          )
        else
          Expanded(
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
                              builder: (context) =>
                                  JogadorInfoView(cpf: jogador.cpf),
                            ),
                          );
                        },
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.person,
                                  size: 50, color: Colors.grey),
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
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF7F1019),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child:
                            const Icon(Icons.close, color: Colors.white, size: 26),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
