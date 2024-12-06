import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/visualizacion_pokemon_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practico2labo4/models/model_ability.dart'; // Archivo donde está definido el modelo Ability

class AbilityListItem extends StatefulWidget {
  final String url;
  const AbilityListItem({super.key, required this.url});

  @override
  State<AbilityListItem> createState() => _AbilityListItemState();
}

class _AbilityListItemState extends State<AbilityListItem> {
  Ability? ability;
  Map<String, bool> favoriteAbilities = {}; // Mapa para favoritos
  Set<int> selectedPokemonIds = {}; // Para manejar los Pokémon seleccionados
  int? tappedPokemonId; // Para manejar el Pokémon que está siendo presionado

  final apiImageUrl = dotenv.env['API_IMAGE_URL'];

  @override
  void initState() {
    super.initState();
    fetchAbility();
    loadFavorites();
  }

  Future<void> fetchAbility() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        ability = Ability.fromJson(json.decode(response.body));
      });
    } else {
      throw Exception('Error al cargar la habilidad');
    }
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favoriteAbilities', json.encode(favoriteAbilities));
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getString('favoriteAbilities');
    if (storedFavorites != null) {
      setState(() {
        favoriteAbilities =
            Map<String, bool>.from(json.decode(storedFavorites));
      });
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
                          'Ability Name:\n${ability?.name?.toUpperCase()}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 48, 73),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (ability?.flavorTextEntries != null &&
                          ability!.flavorTextEntries!.isNotEmpty)
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
                                  ability!.flavorTextEntries![1].flavorText ??
                                      'No description available',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 237, 242, 244),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (ability?.effectEntries != null &&
                          ability!.effectEntries!.isNotEmpty)
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
                                  ability!.effectEntries![1].effect ??
                                      'No effect available',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text(
                            'Add to favorites:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Switch(
                            value:
                                favoriteAbilities[ability?.name ?? ''] ?? false,
                            onChanged: (value) {
                              setState(() {
                                favoriteAbilities[ability?.name ?? ''] = value;
                              });
                              saveFavorites();
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
                        children: ability?.pokemon?.map((pokemon) {
                              final pokemonName = pokemon.pokemon?.name ?? '';
                              final pokemonUrl = pokemon.pokemon?.url ?? '';
                              final pokemonId = extractPokemonId(pokemonUrl);
                              final imageUrl = '$apiImageUrl$pokemonId.png';
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          VisualizacionPokemonScreen(
                                              url: pokemonUrl),
                                    ),
                                  );
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                //Cuando se mantiene precionado
                                //cambia el color de fondo
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
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: tappedPokemonId == pokemonId
                                        ? const Color.fromARGB(
                                            255, 141, 153, 174)
                                        : const Color.fromARGB(255, 43, 45, 66),
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
                                    leading: CachedNetworkImage(
                                      imageUrl: imageUrl,
                                      width: 50,
                                      height: 50,
                                      placeholder: (context, url) =>
                                          const CircularProgressIndicator(),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                              'assets/images/pokeball.png'),
                                    ),
                                    title: Text(
                                      pokemonName.toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 237, 242, 244),
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Visibility(
                                          visible: pokemon.isHidden ?? false,
                                          child: const Text(
                                            'Hidden ability',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const Icon(Icons.chevron_right,
                                            color: Color.fromARGB(
                                                255, 237, 242, 244)),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList() ??
                            [],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  int extractPokemonId(String url) {
    final idMatch = RegExp(r'/(\d+)/$').firstMatch(url);
    return idMatch != null ? int.parse(idMatch.group(1)!) : 0;
  }
}
