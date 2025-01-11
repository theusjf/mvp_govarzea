import 'dart:io';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:mvp_govarzea/pages/signup/signup_time.dart';
import 'package:mvp_govarzea/models/usuarios.dart';
import '../../widgets/custom_text_field.dart';
import '../home_view/home_view.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmController = TextEditingController();
  int idUserAtual = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 50),
              child: Text(
                "Registrar-se",
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    labelText: "Seu nome:",
                    hintText: "Digite seu nome",
                    controller: _nomeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Digite um nome válido';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    labelText: "Seu email:",
                    hintText: "Digite seu email",
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty || !EmailValidator.validate(value)) {
                        return 'Digite um e-mail válido';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    labelText: "Sua senha:",
                    hintText: "Digite sua senha",
                    obscureText: true,
                    controller: _senhaController,
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'A senha deve ter no mínimo 8 caracteres';
                      }
                      return null;
                    },
                  ),
                  CustomTextField(
                    labelText: "Confirme sua senha:",
                    hintText: "Repita sua senha",
                    obscureText: true,
                    controller: _confirmController,
                    validator: (value) {
                      if (value != _senhaController.text) {
                        return 'As senhas não coincidem';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () {
                        registrarUsuario();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Registrar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void registrarUsuario() {
    if (_formKey.currentState!.validate()) {
      final Usuario novoUsuario = Usuario(
        id: idUserAtual,
        nome: _nomeController.text,
        email: _emailController.text,
        senha: _senhaController.text,
      );

      setState(() {
        usuarios.add(novoUsuario);
        idUserAtual++;
      });

      _nomeController.clear();
      _emailController.clear();
      _senhaController.clear();
      _confirmController.clear();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignupTime(usuario: usuarios.last),
        ),
      );
    }
  }
}
