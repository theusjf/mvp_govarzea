import 'package:flutter/material.dart';
import '../../models/usuarios.dart';
import '../../models/times.dart';
import 'dart:io';
import '../home_view/home_view.dart';

class SignupTime extends StatefulWidget {
  final Usuario usuario;

  const SignupTime({super.key, required this.usuario});

  @override
  State<SignupTime> createState() => _SignupTimeState();
}

class _SignupTimeState extends State<SignupTime> {
  Time? _timeSelecionado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 50, bottom: 50),
            child: Text(
              'Escolha seu time',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: times.length,
                itemBuilder: (context, index) {
                  final time = times[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _timeSelecionado = time;
                        widget.usuario.time = time;
                      });
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeView(usuario: widget.usuario),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Image.asset(time.foto.path),
                          ),
                        ),
                        Text(time.nome),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeView(usuario: widget.usuario),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Pular'),
            ),
          ),
        ],
      ),
    );
  }
}

