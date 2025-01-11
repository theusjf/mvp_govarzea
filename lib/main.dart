import 'package:flutter/material.dart';
import 'package:mvp_govarzea/models/posts.dart';
import 'pages/signup/signup.dart';
import 'pages/inicio/inicio.dart';
import 'pages/login/login.dart';



void main() {
  postExemplo();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (_) => const Inicio(),
        '/login': (_) => const Login(),
        '/signup': (_) => const Signup()
      },
    );
  }
}
