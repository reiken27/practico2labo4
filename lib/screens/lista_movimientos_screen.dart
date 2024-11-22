import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/screens.dart';
import 'package:practico2labo4/screens/visualizacion_movimiento_screen.dart';

class ListaMovimientosScreen extends StatefulWidget {
  const ListaMovimientosScreen({super.key});

  @override
  State<ListaMovimientosScreen> createState() => _ListaMovimientosScreenState();
}

class _ListaMovimientosScreenState extends State<ListaMovimientosScreen> {
  List<dynamic> movimientos = [];
  bool isLoading = false;
  String? nextUrl; // URL para la siguiente página de resultados
  bool isDisposed = false; // Para verificar si el widget ha sido desmontado

  @override
  void initState() {
    super.initState();
    fetchMovimientos('https://pokeapi.co/api/v2/move');
  }

  @override
  void dispose() {
    isDisposed = true; // Marca el widget como desmontado
    super.dispose();
  }

  Future<void> fetchMovimientos(String url, {int retries = 3}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!isDisposed) {
          setState(() {
            movimientos.addAll(data['results']);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Movimientos'),
        centerTitle: true,
      ),
      body: isLoading && movimientos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movimientos.length,
              itemBuilder: (context, index) {
                final movimiento = movimientos[index];

                int pokemonId = index + 1;
                String imageUrl = generatePokemonImageUrl(pokemonId);

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 10), // Márgenes alrededor
                  padding: const EdgeInsets.all(10), // Relleno interno
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100, // Fondo amarillo claro
                    borderRadius:
                        BorderRadius.circular(15), // Bordes redondeados
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(4, 4), // Sombra desplazada
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Image.network(
                      imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VisualizacionMovimientoScreen(
                            url: movimiento['url'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  String generatePokemonImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
}
