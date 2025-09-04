import 'package:flutter/material.dart';
import '/widgets/appbar_global.dart';

class CampeonatosView extends StatelessWidget {
  const CampeonatosView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: GlobalAppBar(title: 'Campeonatos'),
      body: Center(child: Text('Campeonatos')
      ),
    );
  }
}
