import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'package:practico2labo4/screens/visualizacion_movimiento_screen.dart'; // Importante para manejar el tiempo de espera y reintentos

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

  // Función para hacer reintentos en la solicitud HTTP
  Future<void> fetchMovimientos(String url, {int retries = 3}) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10)); // Timeout de 10 segundos

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verificar si el widget sigue montado antes de llamar a setState()
        if (!isDisposed) {
          setState(() {
            movimientos.addAll(data['results']); // Agregar los nuevos movimientos a la lista existente
            nextUrl = data['next']; // Establecer la URL de la siguiente página
            isLoading = false;
          });
        }

        // Si hay una URL para la siguiente página, carga los próximos movimientos
        if (nextUrl != null && !isDisposed) {
          fetchMovimientos(nextUrl!);
        }
      } else {
        throw Exception('Error al cargar los movimientos');
      }
    } on TimeoutException catch (_) {
      if (retries > 0) {
        // Si se produce un TimeoutException, intentar de nuevo
        fetchMovimientos(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Tiempo de espera agotado. No se pudo conectar a la API.');
      }
    } on http.ClientException catch (_) {
      if (retries > 0) {
        // Intentar nuevamente si la solicitud fue rechazada
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

                // Generamos una URL de imagen para el movimiento actual (puedes mejorar la lógica para personalizar la imagen)
                int pokemonId = index + 1; // Para probar, generamos un ID de Pokémon basado en el índice (del 1 al 100)
                String imageUrl = generatePokemonImageUrl(pokemonId);

                return ListTile(
                  title: Text(movimiento['name'].toUpperCase()),
                  trailing: Image.network(
                    imageUrl,
                    width: 50, // Ajusta el tamaño de la imagen
                    height: 50,
                    fit: BoxFit.cover,
                  ),
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
                );
              },
            ),
    );
  }

  // Función para generar una URL de imagen de Pokémon para el movimiento (suponiendo que cada movimiento tiene una imagen asociada)
  String generatePokemonImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
}

