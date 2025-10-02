import 'package:flutter/material.dart';
import '/models/time_model.dart';
import 'jogador_info_view.dart';
import '/controllers/time_controller.dart';


class TimeView extends StatefulWidget {
  final Time time;
  const TimeView({super.key, required this.time});

  @override
  State<TimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<TimeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late TimeController controller;
  String? fotoTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    controller = TimeController(widget.time);
    _carregarFotoTime();
  }

  void _carregarFotoTime() async {
    final url = await controller.buscarFoto();
    if (url != null) {
      setState(() {
        fotoTime = url;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.time.nome,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
          _buildNoticias(),
          _buildCalendario(),
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
          Container(
            width: 200,
            height: 150,
            child: fotoTime != null
                ? Image.network(fotoTime!, fit: BoxFit.contain)
                : const Center(
              child: Icon(Icons.shield, size: 100, color: Color(0xFF122E6C)),
            ),
          ),
          const SizedBox(height: 8),
          Text('Localização: ${widget.time.localizacao ?? "Não informada"}',
              style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          Text(
            'Fundação: ${widget.time.fundacao != null ? widget.time.fundacao!.toLocal().toString().split(" ")[0] : "Não informada"}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEscalacao() {
    final jogadores = widget.time.jogadores ?? [];
    if (jogadores.isEmpty) return const Center(child: Text("Nenhum jogador cadastrado."));

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
              MaterialPageRoute(builder: (context) => JogadorInfoView(cpf: jogador.cpf)),
            );
          },
          child: Card(
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person, size: 50, color: Colors.grey),
                  const SizedBox(height: 10),
                  Text(
                    jogador.apelido ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Camisa: ${jogador.numeroCamisa ?? "-"}",
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

  Widget _buildNoticias() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.noticias.length,
      itemBuilder: (context, index) {
        final noticia = controller.noticias[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(noticia.titulo ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  noticia.dataPublicacao != null
                      ? formatarDataHora(noticia.dataPublicacao!)
                      : "",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(noticia.conteudo ?? ""),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCalendario() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.eventos.length,
      itemBuilder: (context, index) {
        final evento = controller.eventos[index];
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
    );
  }

  String formatarDataHora(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');
    return "$dia/$mes/$ano $hora:$minuto";
  }

}
