import 'package:flutter/material.dart';
import '../../controllers/auth_controllers/signup_funcao_controller.dart';
import '../../models/pessoa_models.dart';
import '/widgets/custom_dropdown_field.dart';
import '/widgets/custom_text_field.dart';
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
      body: Center(
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
                  ),
                ),
                const SizedBox(height: 20),

                CustomDropdownField<Role>(
                  labelText: "Função",
                  value: _controller.funcaoSelecionada,
                  items: Role.values,
                  itemLabel: (f) => f.name.replaceAll('ROLE_', ''),
                  onChanged: (valor) {
                    setState(() {
                      _controller.funcaoSelecionada = valor;
                    });
                  },
                  validator: (val) {
                    if (val == null) {
                      return 'Selecione uma função';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 10),

                if (_controller.funcaoSelecionada == Role.ROLE_Jogador) ...[
                  CustomTextField(
                    labelText: "Apelido",
                    hintText: "Digite seu apelido",
                    controller: _controller.apelidoController,
                    validator: _controller.validarCampo,
                  ),
                  CustomTextField(
                    labelText: "Número da Camisa",
                    hintText: "Digite seu número",
                    controller: _controller.numeroCamisaController,
                    validator: _controller.validarCampo,
                  ),
                ],

                if (_controller.funcaoSelecionada == Role.ROLE_Dirigente) ...[
                  CustomTextField(
                    labelText: "Cargo",
                    hintText: "Digite seu cargo como dirigente",
                    controller: _controller.cargoController,
                    validator: _controller.validarCampo,
                  ),
                ],

                if (_controller.funcaoSelecionada == Role.ROLE_Torcedor) ...[
                  CustomTextField(
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
                      final sucesso = await _controller.registrarFuncao(widget.usuario);


                      if (sucesso) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cadastro concluído com sucesso!'),
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
                    backgroundColor: Colors.black,
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
    );
  }
}
