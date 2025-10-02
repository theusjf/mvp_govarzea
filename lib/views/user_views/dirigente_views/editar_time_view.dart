import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';
import '/widgets/custom_text_field.dart';
import '/models/post_model.dart';
import '/controllers/time_controller.dart';
import '/views/jogador_info_view.dart';


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
  String? fotoTime;

  final TextEditingController _controllerTextoPost = TextEditingController();
  final List<Post> posts = [];
  bool criandoNoticia = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    controller.searchJogadores().then((value) {
      setState(() {});
    });

    _carregarFotoTime();
  }

  void _carregarFotoTime() async {
    if (widget.time.idTime != null) {
      final url = await TimeController(widget.time).buscarFoto();
      if (url != null) {
        setState(() {
          fotoTime = url;
        });
      }
    }
  }

  @override
  void dispose() {
    _controllerTextoPost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.time.nome ?? "Time",
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
            Tab(text: 'NOTÍCIAS'),
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
                    final sucesso = await controller.adicionarJogador(widget.time.idTime!, jogador);
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.person, size: 50, color: Colors.grey),
                              const SizedBox(height: 10),
                              Text(
                                jogador.apelido ?? jogador.pessoa.nome,
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
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () async {
                            final sucesso = await controller.removerJogador(widget.time.idTime!, jogador);
                            if (sucesso) {
                              setState(() {
                                widget.time.jogadores?.removeWhere((j) => j.cpf == jogador.cpf);
                              });
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFF7F1019),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: const Icon(Icons.close, color: Colors.white, size: 26),
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


  Widget _buildNoticias() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                criandoNoticia = !criandoNoticia;
              });
            },
            icon: const Icon(Icons.add),
            label: const Text("Nova notícia"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF122E6C),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          if (criandoNoticia)
            Column(
              children: [
                TextField(
                  controller: _controllerTextoPost,
                  decoration: const InputDecoration(
                    hintText: "Digite a notícia...",
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  ),
                  maxLines: 3,
                  textAlignVertical: TextAlignVertical.top,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _criarPost,
                  child: const Text("Postar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF122E6C),
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.time.nome ?? "Time",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        "${post.tempo.day}/${post.tempo.month}/${post.tempo.year} ${post.tempo.hour}:${post.tempo.minute}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Text(post.texto ?? ""),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _criarPost() {
    if (_controllerTextoPost.text.isEmpty) return;

    final post = Post(
      usuario: widget.time.dirigente!.pessoa,
      texto: _controllerTextoPost.text,
      tempo: DateTime.now(),
    );

    setState(() {
      posts.insert(0, post);
      _controllerTextoPost.clear();
      criandoNoticia = false;
    });
  }
}
