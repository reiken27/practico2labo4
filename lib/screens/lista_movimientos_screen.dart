import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart'; // Importación para el sonido
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
  final AudioPlayer _audioPlayer = AudioPlayer(); // Instancia para el sonido
  List<dynamic> movimientos = [];
  List<dynamic> filteredMovimientos = [];
  bool isLoading = false;
  String? nextUrl;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchMovimientos('https://pokeapi.co/api/v2/move');
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMovimientos(String url, {int retries = 3}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!isDisposed) {
          setState(() {
            movimientos.addAll(data['results']);
            filteredMovimientos = List.from(movimientos);
            nextUrl = data['next'];
            isLoading = false;
          });
        }

        if (nextUrl != null && !isDisposed) {
          fetchMovimientos(nextUrl!);
        }
      } else {
        throw Exception('Error al cargar los movimientos');
      }
    } on TimeoutException catch (_) {
      if (retries > 0) {
        fetchMovimientos(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception(
            'Tiempo de espera agotado. No se pudo conectar a la API.');
      }
    } on http.ClientException catch (_) {
      if (retries > 0) {
        fetchMovimientos(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error de conexión. Verifica tu red o la API.');
      }
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
      await _audioPlayer
          .play(AssetSource('sounds/pokeclick.mp3')); // Reproducción del sonido
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
      ),
      body: Stack(
        children: [
          // Fondo de imagen
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
          // Contenido principal
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
                              leading: Image.asset(
                                'assets/images/pokebola.gif',
                                height: 60,
                                width: 60,
                              ),
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
                                await _playClickSound(); // Reproducción del sonido
                                Navigator.push(
                                  // ignore: use_build_context_synchronously
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
