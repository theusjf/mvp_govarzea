import 'package:flutter/material.dart';
import '/models/pessoa_models.dart';
import '/models/time_model.dart';
import '../../../controllers/user_controllers/torcedor_controllers/torcedor_time_controller.dart';
import '/widgets/custom_text_field.dart';

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
    setState(() {
      resultadosBusca = [];
      carregando = false;
    });
  }

  void _onSearchChanged() {
    final query = searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        resultadosBusca = [];
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // alinha à esquerda
          children: [
            const SizedBox(height: 20),
            CustomTextField(
              labelText: 'Pesquisar Time',
              hintText: 'Digite o nome do time',
              controller: searchController,
              icon: const Icon(Icons.search),
            ),
            const SizedBox(height: 10), // menor espaçamento
            if (carregando)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: CircularProgressIndicator(),
              )
            else if (resultadosBusca.isEmpty && searchController.text.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Nenhum time encontrado'),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: 8), // pequeno espaçamento
                  itemCount: resultadosBusca.length,
                  itemBuilder: (context, index) {
                    final time = resultadosBusca[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ExpansionTile(
                        title: Text(time.nome),
                        subtitle: Text('${time.localizacao ?? ""}'),
                        children: (time.jogadores ?? []).map((j) {
                          return ListTile(
                            title: Text(j.apelido ?? j.cpf),
                            subtitle: Text('Camisa: ${j.numeroCamisa ?? "-"}'),
                          );
                        }).toList(),
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
