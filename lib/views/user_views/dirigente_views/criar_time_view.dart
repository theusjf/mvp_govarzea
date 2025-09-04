import 'package:flutter/material.dart';
import '/models/pessoa_models.dart';
import '/models/time_model.dart';
import '../../../controllers/user_controllers/dirigente_controllers/criar_time_controller.dart';
import '/widgets/custom_text_field.dart';

class CriarTimeView extends StatefulWidget {
  final Pessoa dirigente;
  final Time? timeExistente;
  final List<Jogador>? jogadoresDoTime;

  const CriarTimeView({
    super.key,
    required this.dirigente,
    this.timeExistente,
    this.jogadoresDoTime,
  });

  @override
  State<CriarTimeView> createState() => _CriarTimeViewState();
}

class _CriarTimeViewState extends State<CriarTimeView> {
  final CriarTimeController controller = CriarTimeController();
  final _formKey = GlobalKey<FormState>();

  final nomeTimeController = TextEditingController();
  final localizacaoController = TextEditingController();
  final fundacaoController = TextEditingController();

  Dirigente? dirigenteCompleto;

  @override
  void initState() {
    super.initState();
    _inicializarCampos();
    carregarDados();
  }

  void _inicializarCampos() {
    if (widget.timeExistente != null) {
      nomeTimeController.text = widget.timeExistente!.nome;
      localizacaoController.text = widget.timeExistente!.localizacao ?? '';
      fundacaoController.text = widget.timeExistente!.fundacao != null
          ? widget.timeExistente!.fundacao!.toIso8601String().split('T')[0]
          : '';
      controller.jogSelecionados = widget.jogadoresDoTime != null
          ? List.from(widget.jogadoresDoTime!)
          : [];
    }
  }

  Future<void> carregarDados() async {
    dirigenteCompleto = await controller.carregarDados(widget.dirigente.cpf);
    setState(() {});
  }

  void onPesquisaChanged(String input) {
    controller.filtroSugestoes(input);
    setState(() {});
  }

  void adicionarJogador(Jogador jogador) {
    controller.addJogador(jogador);
    setState(() {});
  }

  void removerJogador(Jogador jogador) {
    controller.removerJogador(jogador);
    setState(() {});
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (dirigenteCompleto == null) return;

    DateTime? dataFundacao;
    try {
      dataFundacao = DateTime.parse(fundacaoController.text);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data inválida")),
      );
      return;
    }

    final time = Time(
      idTime: widget.timeExistente?.idTime,
      nome: nomeTimeController.text.trim(),
      localizacao: localizacaoController.text.trim().isEmpty
          ? 'Local não informado'
          : localizacaoController.text.trim(),
      fundacao: dataFundacao,
      dirigente: dirigenteCompleto!,
    );

    int? idTime;
    if (widget.timeExistente == null) {
      idTime = await controller.criarTime(time);
    } else {
      idTime = widget.timeExistente!.idTime;
    }

    if (idTime != null) {
      final sucesso =
      await controller.addJogadores(idTime, controller.jogSelecionados);
      if (sucesso) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Time salvo com sucesso')),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao salvar jogadores')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao salvar o time')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.timeExistente == null ? 'Criar Time' : 'Editar Time',
            style: TextStyle(
              color: Colors.white,
        ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF122E6C),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                labelText: 'Nome do Time',
                hintText: 'Digite o nome do time',
                controller: nomeTimeController,
                validator: (v) =>
                v == null || v.isEmpty ? 'Informe o nome do time' : null,
              ),
              CustomTextField(
                labelText: 'Localização',
                hintText: 'Digite a localização do time',
                controller: localizacaoController,
              ),
              CustomTextField(
                labelText: 'Fundação (YYYY-MM-DD)',
                hintText: 'Digite a data de fundação',
                controller: fundacaoController,
                keyboardType: TextInputType.datetime,
              ),
              CustomTextField(
                labelText: 'Pesquisar jogador',
                hintText: 'Digite o nome do jogador',
                onChanged: onPesquisaChanged,
                icon: const Icon(Icons.search),
              ),
              if (controller.sugestoes.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: controller.sugestoes.length,
                    itemBuilder: (context, index) {
                      final jogador = controller.sugestoes[index];
                      return ListTile(
                        title: Text('${jogador.pessoa.nome} (${jogador.apelido ?? "-"})'),
                        subtitle: Text('CPF: ${jogador.cpf}'),
                        onTap: () => adicionarJogador(jogador),
                      );
                    },
                  ),
                )
              else
                const SizedBox(height: 10),
              const SizedBox(height: 10),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Jogadores selecionados:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.jogSelecionados.length,
                  itemBuilder: (context, index) {
                    final jogador = controller.jogSelecionados[index];
                    return ListTile(
                      title: Text('${jogador.pessoa.nome}'),
                      subtitle: Text('Apelido: ${jogador.apelido}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => removerJogador(jogador),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: salvar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF122E6C),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: Text(widget.timeExistente == null ? 'Criar Time' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
