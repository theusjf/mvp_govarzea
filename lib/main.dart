import 'package:flutter/material.dart';
import 'package:mvp_govarzea/views/splash_screen_view.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Govarzea',
      home: SplashScreen(),
    );
  }
}
