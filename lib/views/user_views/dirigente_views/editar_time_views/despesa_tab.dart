import 'package:flutter/material.dart';
import '/database/despesas_db.dart';
import '/models/despesa_model.dart';
import '/models/time_model.dart';

class DespesasTab extends StatefulWidget {
  final Time time;

  const DespesasTab({super.key, required this.time});

  @override
  State<DespesasTab> createState() => _DespesasTabState();
}

class _DespesasTabState extends State<DespesasTab> {
  final db = DespesaDB.instance;
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  List<Despesa> relatorios = [];

  @override
  void initState() {
    super.initState();
    _carregarRelatorios();
  }

  void _carregarRelatorios() async {
    final data = await db.listarRelatoriosPorTime(widget.time.idTime!);
    setState(() => relatorios = data);
  }

  void _salvarRelatorio() async {
    if (_tituloController.text.isEmpty || _valorController.text.isEmpty) return;

    final novoRelatorio = Despesa(
      titulo: _tituloController.text,
      descricao: _descricaoController.text,
      valor: double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0,
      data: DateTime.now().toIso8601String(),
      timeId: widget.time.idTime!,
    );

    await db.inserirRelatorio(novoRelatorio);
    _tituloController.clear();
    _descricaoController.clear();
    _valorController.clear();

    _carregarRelatorios();
  }

  void _deletarRelatorio(int id) async {
    await db.deletarRelatorio(id);
    _carregarRelatorios();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _tituloController,
            decoration: const InputDecoration(labelText: 'Título'),
          ),
          TextField(
            controller: _descricaoController,
            decoration: const InputDecoration(labelText: 'Descrição'),
          ),
          TextField(
            controller: _valorController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Valor (R\$)'),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _salvarRelatorio,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF122E6C),
            ),
            child: const Text(
              'Salvar Relatório',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: relatorios.length,
              itemBuilder: (context, index) {
                final r = relatorios[index];
                return ListTile(
                  title: Text(r.titulo),
                  subtitle: Text(
                    'R\$ ${r.valor.toStringAsFixed(2)} - ${r.data.split("T")[0]}',
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deletarRelatorio(r.id!),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
