import 'package:flutter/material.dart';
import '../../controllers/auth_controllers/signup_funcao_controller.dart';
import '../../models/pessoa_models.dart';
import '/widgets/custom_white_text_field.dart';
import '/views/user_views/user_view.dart';

class SignupFuncaoView extends StatefulWidget {
  final Pessoa usuario;
  const SignupFuncaoView({super.key, required this.usuario});

  @override
  State<SignupFuncaoView> createState() => _SignupFuncaoViewState();
}

class _SignupFuncaoViewState extends State<SignupFuncaoView> {
  final SignupFuncaoController _controller = SignupFuncaoController();

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
          Container(
            color: const Color(0xFF122E6C).withOpacity(0.6),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Selecione sua função',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: Role.values.map((role) {
                        final isSelected = _controller.funcaoSelecionada == role;
                        return ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _controller.funcaoSelecionada = role;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            foregroundColor: isSelected
                                ? const Color(0xFF7F1019)
                                : Colors.white,
                            side: const BorderSide(color: Colors.white),
                            textStyle: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          child: Text(role.name.replaceAll('ROLE_', '')),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 10),

                    if (_controller.funcaoSelecionada == Role.ROLE_Jogador) ...[
                      CustomWhiteTextField(
                        labelText: "Apelido",
                        hintText: "Digite seu apelido",
                        controller: _controller.apelidoController,
                        validator: _controller.validarCampo,
                      ),
                      CustomWhiteTextField(
                        labelText: "Número da Camisa",
                        hintText: "Digite seu número",
                        controller: _controller.numeroCamisaController,
                        validator: _controller.validarCampo,
                      ),
                    ],
                    if (_controller.funcaoSelecionada == Role.ROLE_Dirigente) ...[
                      CustomWhiteTextField(
                        labelText: "Cargo",
                        hintText: "Digite seu cargo como dirigente",
                        controller: _controller.cargoController,
                        validator: _controller.validarCampo,
                      ),
                    ],
                    if (_controller.funcaoSelecionada == Role.ROLE_Torcedor) ...[
                      CustomWhiteTextField(
                        labelText: "Biografia",
                        hintText: "Fale sobre você",
                        controller: _controller.biografiaController,
                        validator: _controller.validarCampo,
                      ),
                    ],

                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_controller.formKey.currentState!.validate()) {
                          final sucesso =
                          await _controller.registrarFuncao(widget.usuario);

                          if (sucesso) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Cadastro concluído com sucesso!'),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    UsuarioView(usuario: widget.usuario),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Erro ao cadastrar função')),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF122E6C),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Finalizar Cadastro'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
