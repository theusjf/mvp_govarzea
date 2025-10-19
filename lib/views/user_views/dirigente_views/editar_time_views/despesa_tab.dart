import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
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
  final _valorController = TextEditingController();
  final _dataController = TextEditingController();
  List<Despesa> relatorios = [];
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('pt_BR', null);
    _carregarRelatorios();
  }

  void _carregarRelatorios() async {
    final data = await db.listarRelatorios(widget.time.idTime!);
    double soma = data.fold(0.0, (s, r) => s + r.valor);
    setState(() {
      relatorios = data;
      total = soma;
    });
  }

  void _adicionarDespesa() async {
    if (_tituloController.text.isEmpty || _valorController.text.isEmpty || _dataController.text.isEmpty) return;

    try {
      DateFormat('dd/MM/yyyy').parseStrict(_dataController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data inválida! Use o formato dia/mês/ano')),
      );
      return;
    }

    final nova = Despesa(
      titulo: _tituloController.text,
      valor: double.tryParse(_valorController.text.replaceAll(',', '.')) ?? 0.0,
      data: _dataController.text,
      timeId: widget.time.idTime!,
    );

    await db.inserirRelatorio(nova);

    _tituloController.clear();
    _valorController.clear();
    _dataController.clear();
    _carregarRelatorios();
  }

  Future<void> _salvarPdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Relatório de Despesas - ${widget.time.nome ?? 'Time'}',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            pw.Table.fromTextArray(
              headers: ['Título', 'Valor (R\$)', 'Data'],
              data: relatorios.map((r) => [r.titulo, r.valor.toStringAsFixed(2), r.data]).toList(),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Total: R\$ ${total.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();
    final directory = await getTemporaryDirectory();
    final filePath = '${directory.path}/relatorio.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    OpenFile.open(filePath);
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
          TextField(controller: _tituloController, decoration: const InputDecoration(labelText: 'Título')),
          TextField(
            controller: _valorController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Valor (R\$)'),
          ),
          TextField(
            controller: _dataController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Data'),
            onChanged: (value) {
              if (value.length == 2 || value.length == 5) {
                _dataController.text = value + '/';
                _dataController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _dataController.text.length));
              }
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _adicionarDespesa,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF122E6C)),
                  child: const Text('Adicionar', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: _salvarPdf,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF122E6C)),
                  child: const Text('Salvar Relatorio', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: relatorios.length,
              itemBuilder: (context, index) {
                final r = relatorios[index];
                return ListTile(
                  title: Text(r.titulo),
                  subtitle: Text('R\$ ${r.valor.toStringAsFixed(2)} - ${r.data}'),
                  trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.grey[800]),
                      onPressed: () => _deletarRelatorio(r.id!)),
                );
              },
            ),
          ),
          const Divider(),
          Text('Total: R\$ ${total.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
