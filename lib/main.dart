import 'package:flutter/material.dart';
import 'package:mvp_govarzea/views/splash_screen_view.dart';
import 'https_overrides.dart';
import 'dart:io';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Govarzea',
      theme: ThemeData(
        primaryColor: const Color(0xFF122E6C),
      ),
      home: SplashScreen(),
    );
  }
}
