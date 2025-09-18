import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/views/jogador_info_view.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';
import '/widgets/custom_text_field.dart';

class EditarTimeView extends StatefulWidget {
  final Time time;
  const EditarTimeView({super.key, required this.time});

  @override
  State<EditarTimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<EditarTimeView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EditarTimeController controller = EditarTimeController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    controller.searchJogadores().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.time.nome ?? "Time",
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF122E6C),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'RESUMO'),
            Tab(text: 'ESCALAÇÃO'),
            Tab(text: 'NOTICIAS'),
            Tab(text: 'CALENDÁRIO'),
            Tab(text: 'RESULTADOS'),
            Tab(text: 'CLASSIFICAÇÃO'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildResumo(),
          _buildEscalacao(),
          const Center(child: Text('Noticias')),
          const Center(child: Text('Calendário')),
          const Center(child: Text('Resultados')),
          const Center(child: Text('Classificação')),
        ],
      ),
    );
  }

  Widget _buildResumo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.shield,
            size: 150,
            color: Color(0xFF122E6C),
          ),
          const SizedBox(height: 8),
          Text('Localização: ${widget.time.localizacao ?? "Não informada"}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            'Fundação: ${widget.time.fundacao != null ? widget.time.fundacao!
                .toLocal().toString().split(" ")[0] : "Não informada"}',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildEscalacao() {
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
                controller.sugestoes.clear();
              } else {
                controller.filtroSugestoes(value, widget.time.jogadores ?? []);
              }
              setState(() {});
            },
            icon: const Icon(Icons.search),
          ),
        ),
        if (controller.sugestoes.isNotEmpty)
          Expanded(
            child: ListView.builder(
              itemCount: controller.sugestoes.length,
              itemBuilder: (context, index) {
                final jogador = controller.sugestoes[index];
                return ListTile(
                  title: Text('${jogador.pessoa.nome} (${jogador.apelido ?? "-"})'),
                  onTap: () async {
                    final sucesso = await controller.adicionarJogador(
                        widget.time.idTime!, jogador);
                    if (sucesso) {
                      setState(() {
                        widget.time.jogadores?.add(jogador);
                        controller.sugestoes.clear();
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
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
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
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () async {
                            final sucesso = await controller.removerJogador(
                                widget.time.idTime!, jogador);
                            if (sucesso) {
                              setState(() {
                                widget.time.jogadores
                                    ?.removeWhere((j) => j.cpf == jogador.cpf);
                              });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF7F1019),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          )
      ],
    );
  }
}
