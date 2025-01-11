import 'package:flutter/material.dart';
import '../../../models/usuarios.dart';
import '../../../models/posts.dart';

class Home extends StatelessWidget {
  final Usuario usuario;
  const Home({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    String primeiroNome = usuario.nome.split(' ').first;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "Olá, $primeiroNome!",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 35,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: posts.length,
        itemBuilder: (context, index) {
          final post = posts[index];

          return Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.grey,
                          backgroundImage: post.usuario.foto != null ? FileImage(post.usuario.foto!) : null,
                          child: post.usuario.foto == null
                              ? Icon(
                            Icons.person,
                            color: Colors.grey[200],
                            size: 25,
                          )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post.usuario.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "${post.tempo.day}/${post.tempo.month}/${post.tempo.year} às ${post.tempo.hour}:${post.tempo.minute}",
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    if (post.texto != null)
                      Text(
                        post.texto!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    const SizedBox(height: 10),
                    if (post.imagem != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          post.imagem!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
