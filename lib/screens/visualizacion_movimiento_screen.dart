import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/models/model_movimientos.dart';

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
  Move? moveData;
  bool isFavorite = false;
  String? pokemonImageUrl;

  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMovimiento();
  }

  Future<void> fetchMovimiento() async {
    try {
      final response = await http.get(Uri.parse(widget.url));

      if (response.statusCode == 200) {
        setState(() {
          movimiento = json.decode(response.body);
          moveData = Move.fromJson(movimiento!); // Map -> Clase Move
        });

        // Obtener imagen del Pokémon aleatorio usando randomId
        final randomId = (DateTime.now().millisecondsSinceEpoch % 898) + 1;
        await fetchPokemonImage(randomId);
      } else {
        throw Exception('Error al cargar el movimiento');
      }
    } catch (e) {
      print('Error al cargar el movimiento: $e');
    }
  }

  Future<void> fetchPokemonImage(int randomId) async {
    final apiImageUrl = dotenv.env['API_IMAGE_URL'];
    if (apiImageUrl == null) {
      print('Error: API_IMAGE_URL no está definida.');
      return;
    }

    final url = '$apiImageUrl$randomId.png';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          pokemonImageUrl = url; // Usar directamente la URL generada
        });
      } else {
        print('Error al cargar la imagen del Pokémon: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar la imagen del Pokémon: $e');
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
                        image: NetworkImage(pokemonImageUrl!),
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
                        _buildDetailsSection(isDarkMode),
                        const SizedBox(height: 24),
                        _buildCommentsAndFavoritesSection(
                          favoriteTextColor,
                          commentTextColor,
                          inputBorderColor,
                          isDarkMode,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildDetailsSection(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: pokemonImageUrl != null
            ? DecorationImage(
                image: NetworkImage(pokemonImageUrl!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/pokemondetalle.jpg'),
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
              color: isDarkMode ? Colors.lightBlue : Colors.teal,
            ),
          ),
          const SizedBox(height: 16),
          if (moveData?.power != null)
            DetailRow(label: 'Poder', value: '${moveData?.power}'),
          if (moveData?.accuracy != null)
            DetailRow(label: 'Precisión', value: '${moveData?.accuracy}'),
          if (moveData?.pp != null)
            DetailRow(label: 'PP', value: '${moveData?.pp}'),
          if (moveData?.effectEntries != null &&
              moveData!.effectEntries!.isNotEmpty)
            DetailRow(
              label: 'Efecto',
              value: '${moveData?.effectEntries?[0].effect}',
            ),
        ],
      ),
    );
  }

  Widget _buildCommentsAndFavoritesSection(
    Color favoriteTextColor,
    Color commentTextColor,
    Color inputBorderColor,
    bool isDarkMode,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentarios y Favoritos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: commentTextColor,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Ingresa un comentario',
            labelStyle: TextStyle(color: commentTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: inputBorderColor),
            ),
          ),
          style: TextStyle(
            color: isDarkMode
                ? const Color.fromARGB(255, 148, 3, 3)
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
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
