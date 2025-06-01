import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '/models/usuario_model.dart';
import '/views/usuario_views/usuario_view.dart';
import '/widgets/custom_text_field.dart';
import '/widgets/custom_dropdown_field.dart';
import '/widgets/custom_date_field.dart';
import '/controllers/signup_controller.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final SignupController _controller = SignupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Text(
                    "Registrar-se",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                ),
                CustomTextField(
                  labelText: "Nome:",
                  hintText: "Digite seu nome",
                  controller: _controller.nomeController,
                  validator: _controller.validarNome,
                ),
                CustomTextField(
                  labelText: "Email:",
                  hintText: "Digite seu email",
                  controller: _controller.emailController,
                  validator: _controller.validarEmail,
                ),
                CustomTextField(
                  labelText: "CPF:",
                  hintText: "Digite seu CPF",
                  controller: _controller.cpfController,
                  validator: _controller.validarCPF,
                ),
                CustomTextField(
                  labelText: "Telefone:",
                  hintText: "Digite seu telefone",
                  controller: _controller.telefoneController,
                  validator: _controller.validarTelefone,
                ),
                CustomDateField(
                  labelText: "Data de nascimento",
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  onDateChanged: (data) {
                    setState(() {
                      _controller.dataNasc = data;
                    });
                  },
                  validator: (_) =>
                      _controller.validarDataNasc(_controller.dataNasc),
                ),
                CustomDropdownField<Funcao>(
                  labelText: "Função",
                  value: _controller.funcaoSelecionada,
                  items: Funcao.values,
                  itemLabel: (f) =>
                  f.name[0].toUpperCase() + f.name.substring(1),
                  onChanged: (novoValor) {
                    setState(() {
                      _controller.funcaoSelecionada = novoValor;
                    });
                  },
                  validator: (_) =>
                      _controller.validarFuncao(_controller.funcaoSelecionada),
                ),
                CustomTextField(
                  labelText: "Senha:",
                  hintText: "Digite sua senha",
                  obscureText: true,
                  controller: _controller.senhaController,
                  validator: _controller.validarSenha,
                ),
                CustomTextField(
                  labelText: "Confirme sua senha:",
                  hintText: "Repita sua senha",
                  obscureText: true,
                  controller: _controller.confirmController,
                  validator: _controller.validarConfirmSenha,
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: ElevatedButton(
                    onPressed: () async {
                      final sucesso = await _controller.registrarUsuario();
                      if (sucesso) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Cadastro realizado com sucesso!")),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UsuarioView(
                                usuario: _controller.novoUsuario!),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Erro ao cadastrar o usuário")),
                        );
                      }
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
        ),
      ),
    );
  }
}
