import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../widgets/appbar_global.dart';
import '/models/pessoa_models.dart';
import '/models/time_model.dart';
import '../../../controllers/user_controllers/torcedor_controllers/torcedor_time_controller.dart';
import '/widgets/custom_text_field.dart';
import 'info_time_view/info_time_view.dart';

class TorcedorTimeView extends StatefulWidget {
  final Pessoa usuario;
  const TorcedorTimeView({super.key, required this.usuario});

  @override
  State<TorcedorTimeView> createState() => _TorcedorTimeViewState();
}

class _TorcedorTimeViewState extends State<TorcedorTimeView> {
  final TorcedorTimeController controller = TorcedorTimeController();
  final TextEditingController searchController = TextEditingController();
  List<Time> resultadosBusca = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarTimes();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> carregarTimes() async {
    setState(() => carregando = true);
    await controller.carregarTimes();

    final prefs = await SharedPreferences.getInstance();

    for (var time in controller.todosTimes) {
      final cachedUrl = prefs.getString('time_${time.idTime}_foto');
      if (cachedUrl != null) {
        time.fotoPath = cachedUrl;
      } else {
        final foto = await controller.buscarFoto(time.idTime!);
        if (foto != null) {
          time.fotoPath = foto;
          await prefs.setString('time_${time.idTime}_foto', foto);
        }
      }
    }

    setState(() {
      resultadosBusca = List<Time>.from(controller.todosTimes);
      carregando = false;
    });
  }

  void _onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        resultadosBusca = List<Time>.from(controller.todosTimes);
      } else {
        resultadosBusca = controller.todosTimes.where((time) {
          return time.nome.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GlobalAppBar(title: 'Times'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextField(
              labelText: 'Pesquisar Time',
              hintText: 'Digite o nome do time',
              controller: searchController,
              icon: const Icon(Icons.search),
            ),
            const SizedBox(height: 10),
            if (carregando)
              const Center(child: CircularProgressIndicator())
            else if (resultadosBusca.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Nenhum time encontrado'),
              )
            else
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(top: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: resultadosBusca.length,
                  itemBuilder: (context, index) {
                    final time = resultadosBusca[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => InfoTimeView(time: time),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 64,
                                height: 64,
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
                              const SizedBox(height: 12),
                              Text(
                                time.nome,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
