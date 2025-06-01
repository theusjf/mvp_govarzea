import 'package:flutter/material.dart';
import '/views/splash_screen_view.dart';
import '/models/post_model.dart';

void main() {
  postExemplo();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
