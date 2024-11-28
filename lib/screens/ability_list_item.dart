import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/visualizacion_pokemon_screen.dart';

class AbilityListItem extends StatefulWidget {
  final String url;
  const AbilityListItem({super.key, required this.url});

  @override
  State<AbilityListItem> createState() => _AbilityListItemState();
}

class _AbilityListItemState extends State<AbilityListItem> {
  Map<String, dynamic>? ability;

  @override
  void initState() {
    super.initState();
    fetchAbility();
  }

  Future<void> fetchAbility() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        ability = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar la habilidad');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ability Detail'),
      ),
      body: ability == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
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
                          'Ability Name:\n${ability?['name']?.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (ability?['flavor_text_entries'] != null &&
                          (ability?['flavor_text_entries'] as List).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Description: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${ability?['flavor_text_entries'][1]['flavor_text'] ?? 'No description available'}',
                                  style: const TextStyle(
                                      fontSize: 16, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (ability?['effect_entries'] != null &&
                          (ability?['effect_entries'] as List).isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Effect: ',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${ability?['effect_entries'][1]['effect'] ?? 'No effect available'}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Lista de Pokémon asociados
                      const Text(
                        'Pokémon with this ability:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children:
                            (ability?['pokemon'] as List).map((pokemonData) {
                          final pokemonName = pokemonData['pokemon']['name'];
                          final pokemonUrl = pokemonData['pokemon']['url'];
                          final pokemonId = extractPokemonId(pokemonUrl);
                          final imageUrl = generatePokemonImageUrl(pokemonId);

                          return ListTile(
                            leading: Image.network(
                              imageUrl,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            title: Text(
                              pokemonName.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      VisualizacionPokemonScreen(
                                    url: pokemonData['pokemon']['url'],
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  String generatePokemonImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  int extractPokemonId(String url) {
    final idMatch = RegExp(r'/(\d+)/$').firstMatch(url);
    return idMatch != null ? int.parse(idMatch.group(1)!) : 0;
  }
}

class PokemonDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;

  const PokemonDetailScreen(this.name, this.imageUrl, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name.toUpperCase()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(imageUrl, width: 200, height: 200),
            const SizedBox(height: 16),
            Text(
              name.toUpperCase(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
