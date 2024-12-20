
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/models/model_movimientos.dart';
import 'package:practico2labo4/widgets/Haag_Gomez_Gaston.dart/details_section.dart';
import 'package:practico2labo4/widgets/Haag_Gomez_Gaston.dart/comments_and_favorites_section.dart';

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
          moveData = Move.fromJson(movimiento!); 
        });

       
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
          pokemonImageUrl = url; 
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
                        DetailsSection(
                          isDarkMode: isDarkMode,
                          moveData: moveData,
                          pokemonImageUrl: pokemonImageUrl,
                        ),
                        const SizedBox(height: 24),
                        CommentsAndFavoritesSection(
                          favoriteTextColor: favoriteTextColor,
                          commentTextColor: commentTextColor,
                          inputBorderColor: inputBorderColor,
                          isFavorite: isFavorite,
                          onFavoriteChanged: (value) {
                            setState(() {
                              isFavorite = value;
                            });
                          },
                          controller: _controller,
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
