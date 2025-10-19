import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/controllers/auth_controllers/login_controller.dart';
import '/views/splash_screen_view.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final email = prefs.getString('email');
  final senha = prefs.getString('senha');

  Widget initialScreen;

  if (email != null && senha != null) {
    final loginController = LoginController();
    final usuarioView = await loginController.autoLogin(email, senha);

    if (usuarioView != null) {
      initialScreen = usuarioView;
    } else {
      initialScreen = const SplashScreen();
    }
  } else {
    initialScreen = const SplashScreen();
  }

  runApp(MyApp(initialScreen: initialScreen));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Govarzea',
      theme: ThemeData(
        primaryColor: const Color(0xFF122E6C),
      ),
      home: initialScreen,
    );
  }
}
