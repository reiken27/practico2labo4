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
        centerTitle: true,
      ),
      body: movimiento == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
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
                            movimiento?['name']?.toUpperCase() ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Detalles destacados
                        const Text(
                          'Detalles Destacados',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 16),

                        if (movimiento?['power'] != null)
                          DetailRow(
                            label: 'Poder',
                            value: '${movimiento?['power']}',
                          ),
                        if (movimiento?['accuracy'] != null)
                          DetailRow(
                            label: 'Precisión',
                            value: '${movimiento?['accuracy']}',
                          ),
                        if (movimiento?['pp'] != null)
                          DetailRow(
                            label: 'PP',
                            value: '${movimiento?['pp']}',
                          ),
                        if (movimiento?['effect_entries'] != null &&
                            (movimiento?['effect_entries'] as List).isNotEmpty)
                          DetailRow(
                            label: 'Efecto',
                            value:
                                '${movimiento?['effect_entries'][0]['effect']}',
                          ),

                        const SizedBox(height: 24),

                        // Comentarios y favoritos
                        const Text(
                          'Comentarios y Favoritos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 150, 0, 0),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Campo de comentarios
                        TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Ingresa un comentario',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Switch para marcar como favorito
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Es favorito:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

// Widget para fila de detalle
class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.indigo,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
