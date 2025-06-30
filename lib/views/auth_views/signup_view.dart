import 'package:flutter/material.dart';
import 'package:mvp_govarzea/views/signup_funcao_view.dart';
import '/controllers/signup_controller.dart';
import '/widgets/custom_text_field.dart';
import 'login_view.dart';

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
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _controller.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  "Registrar-se",
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                CustomTextField(
                  labelText: "Nome:",
                  hintText: "Digite seu nome",
                  controller: _controller.nomeController,
                  validator: _controller.validarNome,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  labelText: "Email:",
                  hintText: "Digite seu email",
                  controller: _controller.emailController,
                  validator: _controller.validarEmail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  labelText: "CPF:",
                  hintText: "Digite seu CPF",
                  controller: _controller.cpfController,
                  validator: _controller.validarCPF,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  labelText: "Telefone:",
                  hintText: "Digite seu telefone",
                  controller: _controller.telefoneController,
                  validator: _controller.validarTelefone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  labelText: "Senha:",
                  hintText: "Digite sua senha",
                  obscureText: true,
                  controller: _controller.senhaController,
                  validator: _controller.validarSenha,
                ),
                const SizedBox(height: 10),

                CustomTextField(
                  labelText: "Confirme sua senha:",
                  hintText: "Repita sua senha",
                  obscureText: true,
                  controller: _controller.confirmController,
                  validator: _controller.validarConfirmSenha,
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      final sucesso = await _controller.registrarPessoa();
                      if (sucesso) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cadastro realizado com sucesso"),
                          ),
                        );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                SignupFuncaoView(usuario: _controller.novoUsuario!),
                          ),
                        );
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Erro ao cadastrar o usuário"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Registrar',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Já possui uma conta? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      },
                      child: const Text(
                        'Entre',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
