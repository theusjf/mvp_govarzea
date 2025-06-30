import 'package:flutter/material.dart';
import '/models/pessoa_models.dart';
import '/views/user_views/criar_post_view.dart';
import '/views/user_views/home_view.dart';
import '/views/user_views/painel_view.dart';
import '/views/user_views/perfil_view.dart';
import '/views/user_views/dirigente_views/dirigente_time_view.dart';
import '/views/user_views/jogador_views/jogador_time_view.dart';
import '/views/user_views/torcedor_views/torcedor_time_view.dart';

class UsuarioViewsController {
  final Pessoa usuario;

  UsuarioViewsController({required this.usuario});

  List<Widget> get pages => [
    HomeView(usuario: usuario),
    PainelView(usuario: usuario),
    CriarView(usuario: usuario),
    timeView,
    PerfilView(usuario: usuario),
  ];

  Widget get timeView {
    switch (usuario.tipoPerfil) {
      case Role.ROLE_Dirigente:
        return DirigenteTimeView(dirigente: usuario);
      case Role.ROLE_Jogador:
        return JogadorTimeView(usuario: usuario);
      case Role.ROLE_Torcedor:
        return TorcedorTimeView(usuario: usuario);
      default:
        return TorcedorTimeView(usuario: usuario);
    }
  }
}
