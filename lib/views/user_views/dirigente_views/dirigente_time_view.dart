import 'package:flutter/material.dart';
import '../../../widgets/appbar_global.dart';
import '/models/pessoa_models.dart';
import '/models/time_model.dart';
import '../../../controllers/user_controllers/dirigente_controllers/dirigente_time_controller.dart';
import 'criar_time_view.dart';
import 'editar_time_view.dart';

class DirigenteTimeView extends StatefulWidget {
  final Pessoa dirigente;
  const DirigenteTimeView({super.key, required this.dirigente});

  @override
  State<DirigenteTimeView> createState() => _DirigenteTimeViewState();
}

class _DirigenteTimeViewState extends State<DirigenteTimeView> {
  final DirigenteTimeController controller = DirigenteTimeController();
  Future<List<Time>>? futureTimes;

  @override
  void initState() {
    super.initState();
    _carregarTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlobalAppBar(title: 'Meus Times'),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Time>>(
              future: futureTimes ?? Future.value([]),
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

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: times.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final time = times[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditarTimeView(time: time),
                            ),
                          ).then((_) => _carregarTimes());
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  child: time.fotoPath != null
                                      ? Image.network(
                                    time.fotoPath!,
                                    fit: BoxFit.contain,
                                  )
                                      : const Center(
                                    child: Icon(
                                      Icons.shield,
                                      size: 48,
                                      color: Color(0xFF122E6C),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  time.nome,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
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
                    builder: (context) =>
                        CriarTimeView(dirigente: widget.dirigente),
                  ),
                );
                _carregarTimes();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF122E6C),
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

  void _carregarTimes() async {
    final times = (await controller.listTimes())
        .where((time) => time.dirigente?.cpf == widget.dirigente.cpf)
        .toList();

    for (var time in times) {
      if (time.fotoPath == null) {
        final foto = await controller.buscarFoto(time.idTime!);
        time.fotoPath = foto;
      }
    }

    if (mounted) {
      setState(() {
        futureTimes = Future.value(times);
      });
    }
  }

  void _removerTime(int idTime) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmação'),
        content: const Text('Deseja realmente excluir este time?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final sucesso = await controller.removerTime(idTime);

    if (!mounted) return;

    if (sucesso) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Time removido com sucesso')));
      _carregarTimes();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Falha ao remover time')));
    }
  }
}
