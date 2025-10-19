import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/controllers/jogador_info_controller.dart';
import '/widgets/appbar_global.dart';
import 'package:http/http.dart' as http;

class JogadorInfoView extends StatefulWidget {
  final String cpf;
  const JogadorInfoView({super.key, required this.cpf});

  @override
  State<JogadorInfoView> createState() => _JogadorInfoViewState();
}

class _JogadorInfoViewState extends State<JogadorInfoView> {
  late JogadorInfoController controller;
  bool loading = true;
  Uint8List? fotoBytes;

  @override
  void initState() {
    super.initState();
    controller = JogadorInfoController();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await controller.carregarJogador(widget.cpf);
      await _loadFoto();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _loadFoto() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedBytes = prefs.getString('jogador_${widget.cpf}_foto_bytes');

    if (cachedBytes != null) {
      setState(() => fotoBytes = Uint8List.fromList(cachedBytes.codeUnits));
    } else if (controller.fotoUrl != null) {
      final response = await http.get(Uri.parse(controller.fotoUrl!));
      if (response.statusCode == 200) {
        fotoBytes = response.bodyBytes;
        await prefs.setString('jogador_${widget.cpf}_foto_bytes', String.fromCharCodes(fotoBytes!));
        setState(() {});
      }
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[400],
              child: fotoBytes != null
                  ? ClipOval(
                child: Image.memory(
                  fotoBytes!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
                  : controller.fotoUrl == null
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
    );
  }
}
