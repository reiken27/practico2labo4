import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisualizacionPokemonScreen extends StatefulWidget {
  final String url;
  const VisualizacionPokemonScreen({super.key, required this.url});

  @override
  State<VisualizacionPokemonScreen> createState() =>
      _VisualizacionPokemonScreenState();
}

class _VisualizacionPokemonScreenState
    extends State<VisualizacionPokemonScreen> {
  Map<String, dynamic>? pokemon;
  bool isFavorite = false;
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPokemon();
  }

  Future<void> fetchPokemon() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        setState(() {
          pokemon = json.decode(response.body);
        });
      } else {
        throw Exception('Error al cargar los detalles del Pokémon');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  String? getPokemonSprite() {
    return pokemon?['sprites']?['other']?['official-artwork']?['front_default'];
  }

  List<dynamic> getPokemonTypes() {
    return pokemon?['types'] ?? [];
  }

  List<dynamic> getPokemonStats() {
    return pokemon?['stats'] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //appbar text color
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 24,
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        title: Text(pokemon == null
            ? 'Cargando Pokémon...'
            : '${pokemon?['name']?.toUpperCase() ?? "Pokémon"}'),
        backgroundColor: _getTypeColor(getPokemonTypes().isNotEmpty
            ? getPokemonTypes().first['type']['name']
            : ''),
      ),
      body: pokemon == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  color: _getCardBackgroundColor(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (getPokemonSprite() != null)
                          Image.network(
                            getPokemonSprite()!,
                            height: 200,
                            width: 200,
                            fit: BoxFit.contain,
                          ),
                        const SizedBox(height: 16),
                        Text(
                          pokemon?['name']?.toUpperCase() ?? '',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 16,
                          children: getPokemonTypes()
                              .map<Widget>(
                                (type) => Chip(
                                  label: Text(
                                    type['type']['name'].toUpperCase(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor:
                                      _getTypeColor(type['type']['name']),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Column(
                          children: getPokemonStats()
                              .map((stat) => Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        stat['stat']['name']
                                            .toUpperCase()
                                            .replaceAll('-', ' '),
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        stat['base_stat'].toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Es favorito:',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            Switch(
                              value: isFavorite,
                              activeColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              onChanged: (value) {
                                setState(() {
                                  isFavorite = value;
                                });
                              },
                            ),
                          ],
                        ),
                        TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            labelText: 'Agregar comentario',
                            labelStyle: TextStyle(color: Colors.white70),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'fire':
        return Colors.red.shade400;
      case 'water':
        return Colors.blue.shade400;
      case 'grass':
        return Colors.green.shade400;
      case 'electric':
        return Colors.yellow.shade400;
      case 'ice':
        return Colors.cyan.shade300;
      case 'fighting':
        return Colors.orange.shade400;
      case 'poison':
        return Colors.purple.shade400;
      case 'ground':
        return Colors.brown.shade400;
      case 'flying':
        return Colors.indigo.shade300;
      case 'psychic':
        return Colors.pink.shade300;
      case 'bug':
        return Colors.lightGreen.shade400;
      case 'rock':
        return Colors.grey.shade400;
      case 'ghost':
        return Colors.deepPurple.shade400;
      case 'dragon':
        return Colors.indigo.shade500;
      case 'dark':
        return Colors.black54;
      case 'steel':
        return Colors.blueGrey.shade400;
      case 'fairy':
        return Colors.pink.shade200;
      default:
        return Colors.grey.shade300;
    }
  }

  Color _getCardBackgroundColor() {
    if (pokemon == null) return Colors.grey.shade200;
    final types = getPokemonTypes();
    if (types.isEmpty) return Colors.grey.shade200;
    return _getTypeColor(types.first['type']['name']);
  }
}
