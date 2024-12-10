import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/visualizacion_movimiento_screen.dart';

class ListaMovimientosScreen extends StatefulWidget {
  const ListaMovimientosScreen({super.key});

  @override
  State<ListaMovimientosScreen> createState() => _ListaMovimientosScreenState();
}

class _ListaMovimientosScreenState extends State<ListaMovimientosScreen> {
  final TextEditingController searchController = TextEditingController();
  final AudioPlayer _audioPlayer = AudioPlayer();
  List<dynamic> movimientos = [];
  List<dynamic> filteredMovimientos = [];
  Map<String, String> movimientoImages = {};
  bool isLoading = false;
  String? nextUrl;
  bool isDisposed = false;

  // URLs desde el archivo .env
  final String? apiUrl = dotenv.env['API_URL'];
  final String? apiImageUrl = dotenv.env['API_IMAGE_URL'];

  @override
  void initState() {
    super.initState();
    final apiUrl = dotenv.env['API_URL'] ?? 'https://localhost:8000/moves';
    fetchMovimientos(1, retries: 3, apiUrl: apiUrl);
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMovimientos(int page,
      {int retries = 3, required String apiUrl}) async {
    if (isDisposed) return;

    setState(() {
      isLoading = true;
    });

    final url = '$apiUrl/moves?page=$page';

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!isDisposed) {
          setState(() {
            movimientos.addAll(data['data']['results']);
            filteredMovimientos = List.from(movimientos);
            isLoading = false;
          });

          for (var movimiento in data['data']['results']) {
            fetchPokemonImage(movimiento['name']);
          }
        }

        if (data['data']['results'].isNotEmpty && !isDisposed) {
          await fetchMovimientos(page + 1, apiUrl: apiUrl);
        }
      } else {
        throw Exception('Error al cargar los movimientos');
      }
    } on TimeoutException catch (_) {
      if (retries > 0) {
        await fetchMovimientos(page, retries: retries - 1, apiUrl: apiUrl);
      } else if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
    } on http.ClientException catch (_) {
      if (retries > 0) {
        await fetchMovimientos(page, retries: retries - 1, apiUrl: apiUrl);
      } else if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
    } finally {
      if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchPokemonImage(String moveName) async {
    final randomId =
        Random().nextInt(898) + 1; // Generar un ID aleatorio válido
    if (apiImageUrl == null) {
      print('Error: API_IMAGE_URL no está definida en el archivo .env');
      return;
    }
    final url = '$apiImageUrl$randomId.png';

    print('Fetching image from: $url'); // Depuración

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          movimientoImages[moveName] =
              url; // Directamente usamos la URL generada
        });
      } else {
        print(
            'Error ${response.statusCode} al cargar la imagen para $moveName');
      }
    } catch (e) {
      print('Error al cargar la imagen del Pokémon: $e');
    }
  }

  void filterMovimientos(String query) {
    setState(() {
      filteredMovimientos = movimientos
          .where((movimiento) =>
              movimiento['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    searchController.clear();
    filterMovimientos('');
  }

  Color generateColorForName(String name) {
    final Random random = Random(name.hashCode);
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
  }

  Future<void> _playClickSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/pokeclick.mp3'));
    } catch (e) {
      print('Error al reproducir el sonido: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Movimientos'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 121, 199, 248),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/pokefondo.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar movimientos...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: clearSearch,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onChanged: filterMovimientos,
                ),
              ),
              Expanded(
                child: isLoading && movimientos.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredMovimientos.length,
                        itemBuilder: (context, index) {
                          final movimiento = filteredMovimientos[index];
                          final color =
                              generateColorForName(movimiento['name']);
                          final imageUrl = movimientoImages[movimiento['name']];

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                  offset: const Offset(4, 4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: imageUrl != null
                                  ? Image.network(
                                      imageUrl,
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox.shrink(),
                              title: Text(
                                movimiento['name'].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.black54),
                              onTap: () async {
                                await _playClickSound();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        VisualizacionMovimientoScreen(
                                      url: movimiento['url'],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
