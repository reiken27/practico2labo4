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
  bool isFavorite = false; // Estado para el switch
  final _formKey = GlobalKey<FormState>(); // Clave del formulario
  final _controller = TextEditingController(); // Controlador para el TextFormField

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen (si se proporcionara)
                    movimiento?['sprites'] != null
                        ? Image.network(
                            movimiento?['sprites']['front_default'] ??
                                'https://via.placeholder.com/150',
                            width: 150,
                            height: 150,
                          )
                        : const SizedBox(height: 150),

                    // Nombre del movimiento
                    Text(
                      'Nombre: ${movimiento?['name']}'.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // Formulario
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // TextFormField
                          TextFormField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Ingresa un comentario',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Switch (o Checkbox)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const Text('Marcar como favorito'),
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

                    const SizedBox(height: 16),
                    Text(
                      'Precisión: ${movimiento?['accuracy'] ?? "N/A"}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Poder: ${movimiento?['power'] ?? "N/A"}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Puntos de poder (PP): ${movimiento?['pp'] ?? "N/A"}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tipo:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movimiento?['type']['name'].toUpperCase() ?? "N/A",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

