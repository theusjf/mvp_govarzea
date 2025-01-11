import 'package:flutter/material.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/fundoimagem.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            top: 110,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'GoVarzea',
                style: TextStyle(
                  fontSize: 70,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
         Positioned(bottom: 110, left: 10, right: 10,
            child: Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Registrar-se',
              style: TextStyle(
                fontSize: 18,
              ),
             ),
            ),
           ),
          ),
        Positioned(bottom: 50, left: 10, right: 10,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Fazer login',
                style: TextStyle(
                  fontSize: 18,
                ),
               ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

