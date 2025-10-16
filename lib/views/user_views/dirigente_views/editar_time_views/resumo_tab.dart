import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '/models/time_model.dart';
import '/controllers/time_controller.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';

class ResumoTab extends StatefulWidget {
  final Time time;
  final EditarTimeController controller;
  const ResumoTab({super.key, required this.time, required this.controller});

  @override
  State<ResumoTab> createState() => _ResumoTabState();
}

class _ResumoTabState extends State<ResumoTab> {
  String? fotoTime;

  @override
  void initState() {
    super.initState();
    _carregarFotoTime();
  }

  void _carregarFotoTime() async {
    if (widget.time.idTime != null) {
      final url = await TimeController(widget.time).buscarFoto();
      if (url != null) setState(() => fotoTime = url);
    }
  }

  Future<void> _pickFotoTime(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final novaUrl =
      await widget.controller.uploadFotoTime(widget.time.idTime!, file);
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

  @override
  Widget build(BuildContext context) {
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
}
