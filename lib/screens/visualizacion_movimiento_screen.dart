import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisualizacionMovimientoScreen extends StatefulWidget {
  final String url;
  const VisualizacionMovimientoScreen({super.key, required this.url});

  @override
  State<VisualizacionMovimientoScreen> createState() =>
      _VisualizacionMovimientoScreenState();
}

class _VisualizacionMovimientoScreenState
    extends State<VisualizacionMovimientoScreen> {
  Map<String, dynamic>? movimiento;
  bool isFavorite = false;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovimiento();
  }

  Future<void> fetchMovimiento() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        movimiento = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar el movimiento');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Movimiento'),
      ),
      body: movimiento == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
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
                      // Título principal
                      Center(
                        child: Text(
                          'Nombre del Movimiento:\n${movimiento?['name']?.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
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
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),

                      if (movimiento?['power'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Text(
                                'Poder: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${movimiento?['power']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (movimiento?['accuracy'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Text(
                                'Precisión: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${movimiento?['accuracy']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (movimiento?['pp'] != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              const Text(
                                'PP: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${movimiento?['pp']}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (movimiento?['effect_entries'] != null &&
                          (movimiento?['effect_entries'] as List).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Efecto: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${movimiento?['effect_entries'][0]['effect']}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
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
                          color: Colors.black54,
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
                            'Es favorito:',
                            style: TextStyle(fontSize: 16),
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
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: movimiento?.length ?? 0,
                        itemBuilder: (context, index) {
                          final key = movimiento!.keys.elementAt(index);
                          final value = movimiento![key].toString();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${key.toUpperCase()}: ',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black87,
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
