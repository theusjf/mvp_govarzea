import 'package:flutter/material.dart';
import '/models/time_model.dart';
import 'jogador_info_view.dart';

class TimeView extends StatefulWidget {
  final Time time;
  const TimeView({super.key, required this.time});

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.time.nome,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),
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

    if (jogadores.isEmpty) {
      return const Center(child: Text("Nenhum jogador cadastrado."));
    }

    return GridView.builder(
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
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JogadorInfoView(cpf: jogador.cpf ?? ""),
              ),
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    jogador.apelido!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Camisa: ${jogador.numeroCamisa!}",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
