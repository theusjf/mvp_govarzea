import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../login/login.dart';
import '../../../models/usuarios.dart';
import '../../signup/signup_time.dart';
import '../../../models/times.dart';

class Perfil extends StatefulWidget {
  final Usuario usuario;
  const Perfil({super.key, required this.usuario});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final imagePicker = ImagePicker();
  File? fotoPerfil;

  @override
  void initState() {
    super.initState();
    fotoPerfil = widget.usuario.foto;
  }

  pick(ImageSource source) async {
    final pickedFile = await imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        fotoPerfil = File(pickedFile.path);
        widget.usuario.foto = fotoPerfil;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 200,
                        color: Colors.white,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.photo_library),
                              title: Text('Selecionar uma foto na galeria'),
                              onTap: () {
                                pick(ImageSource.gallery);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.camera_alt),
                              title: Text('Tirar uma foto'),
                              onTap: () {
                                pick(ImageSource.camera);
                                Navigator.pop(context);
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.delete),
                              title: Text('Remover a foto'),
                              onTap: () {
                                setState(() {
                                  fotoPerfil = null;
                                  widget.usuario.foto = null;
                                  Navigator.pop(context);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                      fotoPerfil != null ? FileImage(fotoPerfil!) : null,
                      child: fotoPerfil == null
                          ? Icon(
                        Icons.person,
                        color: Colors.grey[200],
                        size: 70,
                      )
                          : null,
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        Icons.edit,
                        color: Colors.grey[700],
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  ListTile(
                    title: Text('Nome: ${widget.usuario.nome}'),
                  ),
                  ListTile(
                    title: Text('Email: ${widget.usuario.email}'),
                  ),
                  ListTile(
                    title: widget.usuario.time == null
                        ? Text('Time: Nenhum time selecionado')
                        : Text('Time: ${widget.usuario.time?.nome}'),
                    trailing: widget.usuario.time == null
                        ? IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SignupTime(usuario: widget.usuario),
                          ),
                        );
                      },
                    )
                        : null,
                  ),
                ],
              ),
            ),
            if (widget.usuario.time != null)
              Padding(
                padding: const EdgeInsets.all(15),
                child: Image.asset(
                  width: 300,
                  height: 300,
                  fit: BoxFit.cover,
                  '${widget.usuario.time!.foto.path}',
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Sair'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
