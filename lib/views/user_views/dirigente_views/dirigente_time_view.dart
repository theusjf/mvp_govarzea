import 'package:flutter/material.dart';
import '/models/pessoa_models.dart';
import '/models/time_model.dart';
import '../../../controllers/user_controllers/dirigente_controllers/dirigente_time_controller.dart';
import 'criar_time_view.dart';

class DirigenteTimeView extends StatefulWidget {
  final Pessoa dirigente;
  const DirigenteTimeView({super.key, required this.dirigente});

  @override
  State<DirigenteTimeView> createState() => _DirigenteTimeViewState();
}

class _DirigenteTimeViewState extends State<DirigenteTimeView> {
  final DirigenteTimeController controller = DirigenteTimeController();
  late Future<List<Time>> futureTimes;

  @override
  void initState() {
    super.initState();
    _carregarTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Times')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Time>>(
              future: futureTimes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else {
                  final times = snapshot.data ?? [];
                  if (times.isEmpty) {
                    return const Center(child: Text('Nenhum time cadastrado.'));
                  }

                  return ListView.builder(
                    itemCount: times.length,
                    itemBuilder: (context, index) {
                      final time = times[index];

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ExpansionTile(
                          title: Text(time.nome, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(
                              'Localização: ${time.localizacao}\nFundação: ${time.fundacao?.toLocal().toString().split(' ')[0] ?? 'Não informada'}'),
                          children: [
                            if (time.jogadores == null || time.jogadores!.isEmpty)
                              const Padding(
                                padding: EdgeInsets.all(8),
                                child: Text('Nenhum jogador cadastrado.'),
                              )
                            else
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: time.jogadores!.length,
                                itemBuilder: (context, idx) {
                                  final jogador = time.jogadores![idx];
                                  return ListTile(
                                    title: Text('${jogador.apelido}'),
                                    subtitle: Text('Número ${jogador.numeroCamisa}'),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        _removerJogadorDialog(jogador, time.idTime!);
                                      },
                                    ),
                                  );
                                },
                              ),
                            OverflowBar(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    _editarTimeDialog(time);
                                  },
                                  child: Text('Editar Time', style: TextStyle(color: Colors.grey[700])),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (time.idTime != null) _removerTime(time.idTime!);
                                  },
                                  child: const Text('Excluir Time', style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CriarTimeView(dirigente: widget.dirigente),
                  ),
                );
                _carregarTimes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text('+ Novo Time'),
            ),
          ),
        ],
      ),
    );
  }

  void _carregarTimes() {
    setState(() {
      futureTimes = controller.listTimes().then((times) {
        return times.where((time) => time.dirigente?.cpf == widget.dirigente.cpf).toList();
      });
    });
  }


  void _removerTime(int idTime) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Deseja realmente excluir este time?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm != true) return;

    final sucesso = await controller.removerTime(idTime);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Time removido com sucesso')),
      );
      _carregarTimes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao remover time')),
      );
    }
  }

  void _editarTimeDialog(Time time) {
    final nomeController = TextEditingController(text: time.nome);
    final localizacaoController = TextEditingController(text: time.localizacao);
    DateTime? dataFundacao = time.fundacao;

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Editar Time'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(labelText: 'Nome'),
                    ),
                    TextField(
                      controller: localizacaoController,
                      decoration: const InputDecoration(labelText: 'Localização'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Text('Fundação: '),
                        Text(dataFundacao != null
                            ? dataFundacao!.toLocal().toString().split(' ')[0]
                            : 'Não informada'),
                        IconButton(
                          icon: const Icon(Icons.calendar_today),
                          onPressed: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: dataFundacao ?? DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now(),
                            );
                            if (picked != null) {
                              setStateDialog(() {
                                dataFundacao = picked;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final novoTime = Time(
                  idTime: time.idTime,
                  nome: nomeController.text.trim(),
                  localizacao: localizacaoController.text.trim(),
                  fundacao: dataFundacao,
                  dirigente: time.dirigente,
                );

                final sucesso = await controller.editarTime(novoTime);

                Navigator.pop(context);

                if (sucesso) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Time atualizado com sucesso')),
                  );
                  _carregarTimes();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Falha ao atualizar time')),
                  );
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removerJogadorDialog(Jogador jogador, int idTime) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmação'),
        content: Text('Deseja realmente excluir o jogador ${jogador.pessoa.nome} do time?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Excluir')),
        ],
      ),
    );

    if (confirm != true) return;

    final sucesso = await controller.removerJogador(idTime, jogador.cpf);

    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jogador removido com sucesso')),
      );
      _carregarTimes();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Falha ao remover jogador')),
      );
    }
  }
}
