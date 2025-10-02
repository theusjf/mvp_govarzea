import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';
import '/widgets/custom_text_field.dart';
import '/models/post_model.dart';
import '/controllers/time_controller.dart';
import '/views/jogador_info_view.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditarTimeView extends StatefulWidget {
  final Time time;
  const EditarTimeView({super.key, required this.time});

  @override
  State<EditarTimeView> createState() => _TimeViewState();
}

class _TimeViewState extends State<EditarTimeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final EditarTimeController controller = EditarTimeController();
  String? fotoTime;

  bool criandoNoticia = false;
  bool criandoEvento = false;
  DateTime? _dataEvento;

  final TextEditingController _controllerTituloNoticia = TextEditingController();
  final TextEditingController _controllerConteudoNoticia = TextEditingController();
  final TextEditingController _controllerTituloEvento = TextEditingController();
  final TextEditingController _controllerConteudoEvento = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);

    controller.searchJogadores().then((_) => setState(() {}));
    _carregarFotoTime();

    controller.buscarNoticias(widget.time.idTime!).then((_) => setState(() {}));
    controller.buscarEventos(widget.time.idTime!).then((_) => setState(() {}));
  }

  void _carregarFotoTime() async {
    if (widget.time.idTime != null) {
      final url = await TimeController(widget.time).buscarFoto();
      if (url != null) {
        setState(() => fotoTime = url);
      }
    }
  }

  @override
  void dispose() {
    _controllerTituloNoticia.dispose();
    _controllerConteudoNoticia.dispose();
    _controllerTituloEvento.dispose();
    _controllerConteudoEvento.dispose();
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
          Stack(
            children: [
              Container(
                height: 150,
                alignment: Alignment.center,
                child: fotoTime != null
                    ? Image.network(fotoTime!, fit: BoxFit.contain)
                    : const Icon(Icons.shield, size: 100, color: Color(0xFF122E6C)),
              ),
              Positioned(
                bottom: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => _pickFotoTime(ImageSource.gallery),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                    child: Icon(Icons.edit, size: 20, color: Colors.grey[700]),
                  ),
                ),
              ),
            ],
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

  Future<void> _pickFotoTime(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final novaUrl = await controller.uploadFotoTime(widget.time.idTime!, file);
      if (novaUrl != null) {
        setState(() => fotoTime = "$novaUrl?${DateTime.now().millisecondsSinceEpoch}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto do time atualizada com sucesso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao atualizar a foto do time')),
        );
      }
    }
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
                    final sucesso =
                    await controller.adicionarJogador(widget.time.idTime!, jogador);
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
                              builder: (context) =>
                                  JogadorInfoView(cpf: jogador.cpf),
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
          Center(
            child: ElevatedButton.icon(
              onPressed: () => setState(() => criandoNoticia = !criandoNoticia),
              icon: const Icon(Icons.add),
              label: const Text("Nova notícia"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF122E6C),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (criandoNoticia)
            Column(
              children: [
                TextField(
                  controller: _controllerTituloNoticia,
                  decoration: const InputDecoration(
                    hintText: "Título da notícia...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controllerConteudoNoticia,
                  decoration: const InputDecoration(
                    hintText: "Conteúdo da notícia...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _criarNoticia,
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
                            ? "${noticia.dataPublicacao!.day}/${noticia.dataPublicacao!.month}/${noticia.dataPublicacao!.year} ${noticia.dataPublicacao!.hour}:${noticia.dataPublicacao!.minute}"
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
          ),
        ],
      ),
    );
  }

  void _criarNoticia() async {
    final titulo = _controllerTituloNoticia.text;
    final conteudo = _controllerConteudoNoticia.text;
    if (titulo.isEmpty || conteudo.isEmpty) return;

    final sucesso = await controller.criarNoticia(widget.time.idTime!, titulo, conteudo);

    if (sucesso) {
      _controllerTituloNoticia.clear();
      _controllerConteudoNoticia.clear();
      criandoNoticia = false;
      await controller.buscarNoticias(widget.time.idTime!);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao publicar notícia")),
      );
    }
  }

  String formatarDataHora(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final ano = data.year;
    final hora = data.hour.toString().padLeft(2, '0');
    final minuto = data.minute.toString().padLeft(2, '0');

    return "$dia/$mes/$ano $hora:$minuto";
  }

  Widget _buildCalendario() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          Center(
            child: ElevatedButton.icon(
              onPressed: () => setState(() => criandoEvento = !criandoEvento),
              icon: const Icon(Icons.add),
              label: const Text("Novo evento"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF122E6C),
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (criandoEvento)
            Column(
              children: [
                TextField(
                  controller: _controllerTituloEvento,
                  decoration: const InputDecoration(
                    hintText: "Título do evento...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _controllerConteudoEvento,
                  decoration: const InputDecoration(
                    hintText: "Descrição do evento...",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _dataEvento != null
                            ? "Data: ${formatarDataHora(_dataEvento!)}"
                            : "Selecionar data",
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final dataSelecionada = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2023),
                          lastDate: DateTime(2100),
                          locale: const Locale('pt', 'BR'),
                        );

                        if (dataSelecionada != null) {
                          final horaSelecionada = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (horaSelecionada != null) {
                            setState(() {
                              _dataEvento = DateTime(
                                dataSelecionada.year,
                                dataSelecionada.month,
                                dataSelecionada.day,
                                horaSelecionada.hour,
                                horaSelecionada.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _criarEvento,
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
          ),
        ],
      ),
    );
  }


  void _criarEvento() async {
    final titulo = _controllerTituloEvento.text;
    final conteudo = _controllerConteudoEvento.text;
    if (titulo.isEmpty || conteudo.isEmpty || _dataEvento == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Preencha todos os campos e selecione a data")),
      );
      return;
    }

    final sucesso = await controller.criarEvento(
      widget.time.idTime!,
      titulo,
      conteudo,
      null,
      _dataEvento,
    );

    if (sucesso) {
      _controllerTituloEvento.clear();
      _controllerConteudoEvento.clear();
      _dataEvento = null;
      criandoEvento = false;
      await controller.buscarEventos(widget.time.idTime!);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao publicar evento")),
      );
    }
  }
}
