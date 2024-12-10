import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
  Map<String, Color> typeColors = {};
  final Map<String, List<String>> _pokemonTypesCache = {};
  final apiImageUrl = dotenv.env['API_IMAGE_URL'];

  @override
  void initState() {
    super.initState();
    final apiUrl = dotenv.env['API_URL'] ?? 'https://localhost:8000/id_pokemon';
    fetchPokemon(1, retries: 3, apiUrl: apiUrl);
    initializeTypeColors();
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    super.dispose();
  }

  void initializeTypeColors() {
    typeColors = {
      'normal': const Color.fromARGB(255, 168, 167, 122),
      'fighting': const Color.fromARGB(255, 194, 104, 101),
      'flying': const Color.fromARGB(255, 169, 143, 243),
      'poison': const Color.fromARGB(255, 163, 62, 161),
      'ground': const Color.fromARGB(255, 226, 191, 101),
      'rock': const Color.fromARGB(255, 182, 161, 54),
      'bug': const Color.fromARGB(255, 166, 185, 26),
      'ghost': const Color.fromARGB(255, 115, 87, 151),
      'steel': const Color.fromARGB(255, 183, 183, 206),
      'fire': const Color.fromARGB(255, 238, 129, 48),
      'water': const Color.fromARGB(255, 99, 144, 240),
      'grass': const Color.fromARGB(255, 122, 199, 76),
      'electric': const Color.fromARGB(255, 247, 208, 44),
      'psychic': const Color.fromARGB(255, 249, 85, 135),
      'ice': const Color.fromARGB(255, 150, 217, 214),
      'dragon': const Color.fromARGB(255, 111, 53, 252),
      'dark': const Color.fromARGB(255, 112, 87, 70),
      'fairy': const Color.fromARGB(255, 214, 133, 173),
      'unknown': const Color.fromARGB(255, 190, 190, 190),
      'stellar': const Color.fromARGB(255, 0, 128, 128),
    };
  }

  Future<void> fetchPokemon(int page,
      {int retries = 3, required String apiUrl}) async {
    if (isDisposed) return; 

    setState(() {
      isLoading = true;
    });

    final url = '$apiUrl/pokemon?page=$page';
    
    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!isDisposed) {
          setState(() {
            pokemons.addAll(data['data']['results'].where((newPokemon) =>
                !pokemons.any((existingPokemon) =>
                    existingPokemon['name'] == newPokemon['name'])));
            filteredPokemon = List.from(pokemons);
            isLoading = false;
          });
        }

        if (data['data']['results'].isNotEmpty && !isDisposed) {
          await fetchPokemon(page + 1, apiUrl: apiUrl); 
        }
      } else {
        throw Exception('Error al cargar la lista de Pokémon');
      }
    } on TimeoutException catch (_) {
      if (retries > 0) {
        await fetchPokemon(page, retries: retries - 1, apiUrl: apiUrl);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception(
            'Tiempo de espera agotado. No se pudo conectar a la API.');
      }
    } on http.ClientException catch (_) {
      if (retries > 0) {
        await fetchPokemon(page, retries: retries - 1, apiUrl: apiUrl);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error de conexión. Verifica tu conexión.');
      }
    }
  }

  Future<List<String>> fetchPokemonTypes(String url) async {
    if (_pokemonTypesCache.containsKey(url)) {
      return _pokemonTypesCache[url]!;
    }

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final types = data['types'] as List<dynamic>;
        final typesList =
            types.map((type) => type['type']['name'] as String).toList();

        _pokemonTypesCache[url] = typesList;

        return typesList;
      }
    } catch (e) {
      log(e.toString());
      return [];
    }

    return [];
  }

  void filterPokemon(String query) {
    setState(() {
      filteredPokemon = pokemons.where((pokemon) {
        final name = pokemon['name'].toLowerCase();
        final index = pokemons.indexOf(pokemon) + 1;
        return name.contains(query.toLowerCase()) || index.toString() == query;
      }).toList();
    });
  }

  void clearSearch() {
    searchController.clear();
    filterPokemon('');
  }

  String getPokemonImageUrl(int index) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${index + 1}.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokémon por ID'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 121, 199, 248), 
        foregroundColor: Colors.white, 
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por ID...',
                prefixIcon: const Icon(Icons.search, color: Colors.blue), 
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear, color: Colors.blue), 
                  onPressed: clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blue), // 
                ),
  ),
              onChanged: filterPokemon,
            ),
          ),
          Expanded(
            child: isLoading && pokemons.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                     
                      Positioned.fill(
                        child: Image.asset(
                          'assets/images/pokeback.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                     
                      GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        itemCount: filteredPokemon.length,
                        itemBuilder: (context, index) {
                          final pokemon = filteredPokemon[index];
                          final imageUrl = getPokemonImageUrl(
                              pokemons.indexOf(pokemon)); 
                          final pokemonUrl = pokemon['url'];

                          return FutureBuilder<List<String>>(
                            future: fetchPokemonTypes(pokemonUrl),
                            builder: (context, snapshot) {
                              final types = snapshot.data ?? [];
                              final color = types.isNotEmpty
                                  ? typeColors[types.first] ?? Colors.grey
                                  : Colors.grey;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VisualizacionPokemonidScreen(
                                        url: pokemon['url'],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,  
                                      end: Alignment.bottomCenter,  
                                      colors: [
                                        color.withOpacity(0.3),  
                                        color,  
                                      ],
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.network(
                                        imageUrl,
                                        width: 120,
                                        height: 120,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/pokeball.png',
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                      const SizedBox(height: 1.0),
                                      Text(
                                        '#${pokemons.indexOf(pokemon) + 1}',
                                        style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        pokemon['name'].toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Roboto',
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
