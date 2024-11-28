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
  bool isFavorite = false;
  final _controller = TextEditingController();
  Set<int> selectedPokemonIds = Set(); // Para manejar los Pokémon seleccionados
  int? tappedPokemonId; // Para manejar el Pokémon que está siendo presionado

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
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 43, 45, 66),
      ),
      body: ability == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 239, 35, 60),
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
                            color: Color.fromARGB(255, 0, 48, 73),
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
                                  color: Color.fromARGB(255, 43, 45, 66),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${ability?['flavor_text_entries'][1]['flavor_text'] ?? 'No description available'}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 237, 242, 244),
                                  ),
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
                                  color: Color.fromARGB(255, 43, 45, 66),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${ability?['effect_entries'][1]['effect'] ?? 'No effect available'}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color.fromARGB(255, 237, 242, 244),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: 16),
                      // Lista de Pokémon asociados
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Add to favorites:',
                            style: TextStyle(fontSize: 16),
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
                      const Text(
                        'Pokémon with this ability:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 43, 45, 66),
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

                          return InkWell(
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
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onTapDown: (_) {
                              setState(() {
                                tappedPokemonId =
                                    pokemonId; // Marcar el Pokémon como presionado
                              });
                            },
                            onTapUp: (_) {
                              setState(() {
                                tappedPokemonId =
                                    null; // Quitar el estado de presionado
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                tappedPokemonId =
                                    null; // Quitar el estado si el toque es cancelado
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5.0), // Separación entre elementos
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: tappedPokemonId == pokemonId
                                    ? const Color.fromARGB(255, 141, 153,
                                        174) // Color cuando está siendo presionado
                                    : const Color.fromARGB(
                                        255, 43, 45, 66), // Color normal
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Image.network(
                                  imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.values[0],
                                ),
                                title: Text(
                                  pokemonName.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 237, 242, 244),
                                  ),
                                ),
                                trailing: const Icon(Icons.chevron_right,
                                    color: Color.fromARGB(255, 237, 242, 244)),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const Text(
                        'COMMENTS',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Campo de comentarios
                      TextFormField(
                        style: TextStyle(color: Colors.black),
                        controller: _controller,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'Insert Comment',
                            border: OutlineInputBorder(),
                            fillColor: Colors.white70,
                            filled: true),
                      ),
                      const SizedBox(height: 16),

                      // Switch para marcar como favorito
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
