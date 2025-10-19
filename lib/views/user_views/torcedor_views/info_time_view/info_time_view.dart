import 'package:flutter/material.dart';
import '/models/time_model.dart';
import 'resumo_tab_info.dart';
import 'escalacao_tab_info.dart';
import 'noticias_tab_info.dart';
import 'calendario_tab_info.dart';
import '/controllers/user_controllers/dirigente_controllers/editar_time_controller.dart';

class InfoTimeView extends StatefulWidget {
  final Time time;
  const InfoTimeView({super.key, required this.time});

  @override
  State<InfoTimeView> createState() => _InfoTimeViewState();
}

class _InfoTimeViewState extends State<InfoTimeView>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  late EditarTimeController editarTimeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    editarTimeController = EditarTimeController();
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
          widget.time.nome ?? 'Informações do Time',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF122E6C),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
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
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ResumoTabInfo(time: widget.time, controller: editarTimeController,),
          EscalacaoTabInfo(time: widget.time, controller: editarTimeController),
          NoticiasTabInfo(time: widget.time, controller: editarTimeController),
          CalendarioTabInfo(time: widget.time, controller: editarTimeController),
        ],
      ),
    );
  }
}
