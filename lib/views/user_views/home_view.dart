import 'package:flutter/material.dart';
import '../../widgets/appbar_global.dart';
import '/models/pessoa_models.dart';
import '/models/post_model.dart';
import '/views/user_views/criar_post_view.dart';

class HomeView extends StatefulWidget {
  final Pessoa usuario;
  const HomeView({super.key, required this.usuario});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String primeiroNome = widget.usuario.nome.split(' ').first;

    return Scaffold(
      appBar: GlobalAppBar(title: 'Olá, $primeiroNome!'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CriarView(usuario: widget.usuario),
              )
          );
        },
        backgroundColor: const Color(0xFF122E6C),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}