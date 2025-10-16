import 'package:flutter/material.dart';
import '/models/time_model.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';
import 'resumo_tab.dart';
import 'escalacao_tab.dart';
import 'noticias_tab.dart';
import 'calendario_tab.dart';
import 'resultados_tab.dart';
import 'classificacao_tab.dart';
import 'despesa_tab.dart';

class EditarTimeView extends StatefulWidget {
  final Time time;
  const EditarTimeView({super.key, required this.time});

  @override
  State<EditarTimeView> createState() => _EditarTimeViewState();
}

class _EditarTimeViewState extends State<EditarTimeView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late EditarTimeController controller;

  @override
  void initState() {
    super.initState();
    controller = EditarTimeController();
    _tabController = TabController(length: 7, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.time.nome ?? 'Editar Time',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF122E6C),
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
            Tab(text: 'DESPESAS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ResumoTab(time: widget.time, controller: controller),
          EscalacaoTab(time: widget.time, controller: controller),
          NoticiasTab(time: widget.time, controller: controller),
          CalendarioTab(time: widget.time, controller: controller),
          const ResultadosTab(),
          const ClassificacaoTab(),
          DespesasTab(time: widget.time),

        ],
      ),
    );
  }
}
