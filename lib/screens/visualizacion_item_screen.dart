import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisualizacionItemScreen extends StatefulWidget {
  final String url;
  const VisualizacionItemScreen({super.key, required this.url});

  @override
  State<VisualizacionItemScreen> createState() =>
      _VisualizacionItemScreenState();
}

class _VisualizacionItemScreenState extends State<VisualizacionItemScreen> {
  Map<String, dynamic>? item;
  bool isFavorite = false;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  Future<void> fetchItem() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          item = data; 
        });
      } else {
        throw Exception('Error al cargar el item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el item: $e');
      setState(() {
        item = null; 
      });
    }
  }

  void enviarComentario() {
    final comentario = _controller.text;
    if (comentario.isNotEmpty) {
      print('Comentario enviado: $comentario');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario enviado con éxito')),
      );
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese un comentario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del Item',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: item == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.9),
                        Colors.yellow.withOpacity(0.9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item?['sprites']?['default'] != null)
                        Center(
                          child: Image.network(
                            item!['sprites']['default'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      const SizedBox(height: 24),

                      Center(
                        child: Text(
                          '${item?['name']?.toUpperCase() ?? 'Desconocido'}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 115, 255),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      if (item?['category']?['name'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Categoría: ',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueAccent,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${item?['category']['name']?.toUpperCase() ?? 'Sin Categoría'}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 24),

                      const Text(
                        'DETALLES DESTACADOS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 20, 62, 176),
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (item?['effect_entries'] != null &&
                          (item?['effect_entries'] as List).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Efecto: ',
                                style: TextStyle(
                                  color: Colors.blueAccent,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${item?['effect_entries'][0]['effect'] ?? 'Sin descripción'}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),

                      const Text(
                        'GENERACIONES DE JUEGO EN LAS QUE APARECE EL ÍTEM',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 20, 62, 176),
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (item?['game_indices'] != null) 
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var game in item!['game_indices'])
                              if (game['generation']?['name'] != null && game['game_index'] != null)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text(
                                    '${game['generation']['name'].toUpperCase()} | GAME INDEX: ${game['game_index']}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              else
                                const Text(
                                  'Datos incompletos para uno de los juegos.',
                                  style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                          ],
                        )
                      else
                        const Text(
                          'No hay información de generaciones para este ítem.',
                          style: TextStyle(fontSize: 18, color: Color.fromARGB(255, 0, 0, 0)),
                        ),


                      const Text(
                        'COMENTARIOS Y FAVORITOS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 20, 62, 176),
                        ),
                      ),
                      const SizedBox(height: 8),

                      TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Ingresa un comentario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: enviarComentario,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Enviar Comentario'),
                      ),
                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ES FAVORITO:',
                            style: TextStyle(fontSize: 17),
                          ),
                          Switch(
                            value: isFavorite,
                            onChanged: (value) {
                              setState(() {
                                isFavorite = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
