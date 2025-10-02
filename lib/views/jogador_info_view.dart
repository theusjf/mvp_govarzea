import 'package:flutter/material.dart';
import '/controllers/jogador_info_controller.dart';
import '/widgets/appbar_global.dart';

class JogadorInfoView extends StatefulWidget {
  final String cpf;

  const JogadorInfoView({super.key, required this.cpf});

  @override
  State<JogadorInfoView> createState() => _JogadorInfoViewState();
}

class _JogadorInfoViewState extends State<JogadorInfoView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late JogadorInfoController controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    controller = JogadorInfoController();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await controller.carregarJogador(widget.cpf);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: GlobalAppBar(title: "Jogador"),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: "Informações"),
              Tab(text: "Estatísticas"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.grey[400],
                        backgroundImage: controller.fotoUrl != null
                            ? NetworkImage(controller.fotoUrl!)
                            : null,
                        child: controller.fotoUrl == null
                            ? const Icon(Icons.person, size: 70, color: Colors.white)
                            : null,
                      ),
                      const SizedBox(height: 20),
                      controller.campo("Nome", controller.nomeController),
                      controller.campo("Apelido", controller.apelidoController),
                      controller.campo("Idade", controller.idadeController),
                      controller.campo("Posição", controller.posicaoController),
                      controller.campo("Altura", controller.alturaController),
                      controller.campo("Peso", controller.pesoController),
                      controller.campo("Pé Dominante", controller.peController),
                      controller.campo("Biografia", controller.biografiaController),
                      controller.campo("Time Atual", controller.timeController),
                      controller.campo("Número da Camisa", controller.numeroCamisaController),
                    ],
                  ),
                ),
                const Center(
                  child: Text("Estatísticas"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
