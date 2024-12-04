import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  String? pokemonImageUrl; 

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovimiento();
  }

  // Función para obtener el movimiento y la imagen del Pokémon
  Future<void> fetchMovimiento() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        movimiento = json.decode(response.body);
      });

      // Obtener imagen del Pokémon aleatorio usando randomId
      final randomId =
          (DateTime.now().millisecondsSinceEpoch % 898) + 1; // Generar randomId
      await fetchPokemonImage(randomId); // Obtener la imagen del Pokémon
    } else {
      throw Exception('Error al cargar el movimiento');
    }
  }

  // Función para obtener la imagen del Pokémon
  Future<void> fetchPokemonImage(int randomId) async {
    final apiImageUrl = dotenv.env['API_IMAGE_URL'];
    final url = '$apiImageUrl/pokemon/$randomId/';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        pokemonImageUrl =
            data['sprites']['front_default']; // Obtener la URL de la imagen
      });
    } else {
      throw Exception('Error al cargar la imagen del Pokémon');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final favoriteTextColor = isDarkMode ? Colors.amber : Colors.redAccent;
    final commentTextColor = isDarkMode ? Colors.cyan : Colors.teal;
    final inputBorderColor = isDarkMode ? Colors.grey : Colors.black38;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Movimiento'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 121, 199, 248),
        foregroundColor: Colors.white,
      ),
      body: movimiento == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              decoration: BoxDecoration(
                image: pokemonImageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(
                            pokemonImageUrl!), // Usar la URL obtenida
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.grey[850]!.withOpacity(0.9)
                          : Colors.white.withOpacity(0.9),
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
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.indigo,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Detalles destacados
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: pokemonImageUrl != null
                                ? DecorationImage(
                                    image: NetworkImage(
                                        pokemonImageUrl!), // Usar la URL obtenida
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: AssetImage(
                                        'assets/images/pokemondetalle.jpg'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Detalles Destacados',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: isDarkMode
                                      ? Colors.lightBlue
                                      : Colors.teal,
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
                                  (movimiento?['effect_entries'] as List)
                                      .isNotEmpty)
                                DetailRow(
                                  label: 'Efecto',
                                  value:
                                      '${movimiento?['effect_entries'][0]['effect']}',
                                ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Comentarios y favoritos
                        Text(
                          'Comentarios y Favoritos',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: commentTextColor,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Campo de comentarios
                        TextFormField(
                          controller: _controller,
                          decoration: InputDecoration(
                            labelText: 'Ingresa un comentario',
                            labelStyle: TextStyle(
                              color: commentTextColor,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: inputBorderColor,
                              ),
                            ),
                          ),
                          style: TextStyle(
                            color: isDarkMode
                                ? const Color.fromARGB(255, 148, 3, 3)
                                : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Switch para marcar como favorito
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Es favorito:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: favoriteTextColor,
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

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: isDarkMode
                  ? Colors.lightBlue
                  : const Color.fromARGB(255, 236, 3, 3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode
                    ? const Color.fromARGB(248, 224, 6, 6)
                    : const Color.fromARGB(221, 3, 24, 139),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

