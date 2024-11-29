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

class _VisualizacionItemScreenState
    extends State<VisualizacionItemScreen> {
  Map<String, dynamic>? item;
  bool isFavorite = false;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItem();
  }

  Future<void> fetchItem() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        item = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar el item');
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
            color: Colors.white, // Cambiar el color del texto
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: item == null
          ? const Center(child: CircularProgressIndicator())
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
                    
                      Center(
                        child: Text(
                          'Nombre del Item:\n${item?['name']?.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 20, 62, 176),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Detalles destacados
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
                                  color: Color.fromARGB(255, 71, 119, 250),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                              
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${item?['effect_entries'][0]['effect']}',
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

                      // Comentarios y favoritos
                      const Text(
                        'COMENTARIOS Y FAVORITOS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 20, 62, 176),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Campo de comentarios
                      TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          labelText: 'Ingresa un comentario',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Switch para marcar como favorito
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

                      const SizedBox(height: 16),

                      // Sección de lista completa
                      const Text(
                        'LISTA COMPLETA DE DETALLES',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color.fromARGB(255, 21, 50, 124),
                        ),
                      ),
                      const SizedBox(height: 8),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: item?.length ?? 0,
                        itemBuilder: (context, index) {
                          final key = item!.keys.elementAt(index);
                          final value = item![key].toString();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${key.toUpperCase()}: ',
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 71, 119, 250),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
