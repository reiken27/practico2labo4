import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/screens.dart';

class ListaPokemonidScreen extends StatefulWidget {
  const ListaPokemonidScreen({super.key});

  @override
  State<ListaPokemonidScreen> createState() => _ListaPokemonidScreenState();
}

class _ListaPokemonidScreenState extends State<ListaPokemonidScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> pokemons = [];
  List<dynamic> filteredPokemon = [];
  bool isLoading = false;
  String? nextUrl;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchPokemon('https://pokeapi.co/api/v2/pokemon');
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchPokemon(String url, {int retries = 3}) async {
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
            pokemons.addAll(data['results']);
            filteredPokemon = List.from(pokemons);
            nextUrl = data['next'];
            isLoading = false;
          });
        }

        if (nextUrl != null && !isDisposed) {
          fetchPokemon(nextUrl!);
        }
      } else {
        throw Exception('Error al cargar la lista de Pokémon');
      }
    } on TimeoutException catch (_) {
      if (retries > 0) {
        fetchPokemon(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception(
            'Tiempo de espera agotado. No se pudo conectar a la API.');
      }
    } on http.ClientException catch (_) {
      if (retries > 0) {
        fetchPokemon(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error de conexión. Verifica tu conexión.');
      }
    }
  }

  void filterPokemon(String query) {
    setState(() {
      filteredPokemon = pokemons.where((pokemon) {
        final name = pokemon['name'].toLowerCase();
        final index = pokemons.indexOf(pokemon) + 1; // El índice representa el ID
        return name.contains(query.toLowerCase()) || index.toString() == query;
      }).toList();
    });
  }

  void clearSearch() {
    searchController.clear();
    filterPokemon('');
  }

  String getPokemonImageUrl(int index) {
    // PokeAPI usa IDs consecutivos para generar imágenes oficiales
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokémon'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o ID...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: filterPokemon,
            ),
          ),
          Expanded(
            child: isLoading && pokemons.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Número de columnas
                      childAspectRatio: 1.0, // Relación de aspecto
                      crossAxisSpacing: 8.0, // Espacio entre columnas
                      mainAxisSpacing: 8.0, // Espacio entre filas
                    ),
                    padding: const EdgeInsets.all(8.0),
                    itemCount: filteredPokemon.length,
                    itemBuilder: (context, index) {
                      final pokemon = filteredPokemon[index];
                      final imageUrl = getPokemonImageUrl(
                          pokemons.indexOf(pokemon)); // Ajustar para IDs

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VisualizacionPokemonScreen(
                                url: pokemon['url'],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Aquí se carga la imagen por defecto
                                  return Image.asset(
                                    'assets/images/pokeball.png', // Ruta de tu imagen local
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                '#${pokemons.indexOf(pokemon) + 1}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                pokemon['name'].toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
