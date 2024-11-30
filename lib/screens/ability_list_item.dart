import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/visualizacion_pokemon_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Map<String, bool> favoriteAbilities = {}; // Mapa para favoritos
  Set<int> selectedPokemonIds = {}; // Para manejar los Pokémon seleccionados
  int? tappedPokemonId; // Para manejar el Pokémon que está siendo presionado
  @override
  void initState() {
    super.initState();
    fetchAbility();
    loadFavorites();
  }

  final apiImageUrl = dotenv.env['API_IMAGE_URL'];

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

  //Se guardan los favoritos en el mapa favoriteAbilities como shared_preferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favoriteAbilities', json.encode(favoriteAbilities));
  }

  ///Se cargan los favoritos del mapa favoriteAbilities desde shared_preferences
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
                        //Titulo con el nombre de la habilidad
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
                      //La descripcion de la habilidad
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
                                  //Se extrae el segundo elemento de la lista que
                                  //es la descripcion en ingles (para otro idioma cambiar el valor)
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
                      //Efectoo de la habilidad
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
                                  //Se extrae el segundo elemento de la lista que
                                  //es el efecto en ingles (para otro idioma cambiar el valor)
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
                            //Se agrega el boton de favoritos
                            'Add to favorites:',
                            style: TextStyle(fontSize: 16),
                          ),
                          Switch(
                            value: favoriteAbilities[ability?['name'] ?? ''] ??
                                false,
                            onChanged: (value) {
                              setState(() {
                                favoriteAbilities[ability?['name'] ?? ''] =
                                    !(favoriteAbilities[
                                            ability?['name'] ?? ''] ??
                                        false);
                              });
                              saveFavorites(); // Guarda los favoritos
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
                      //Lista de pokemon con la habilidad
                      Column(
                        children: (ability?['pokemon'] as List? ?? [])
                            .map((pokemonData) {
                          final pokemonName = pokemonData['pokemon']['name'];
                          final pokemonUrl = pokemonData['pokemon']['url'];
                          final pokemonId = extractPokemonId(pokemonUrl);
                          final imageUrl = '$apiImageUrl$pokemonId.png';
                          //Se agrega el boton del pokemon con sus respectivas caracteristicas
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
                              //Aca se muestra la imagen del pokemon y se cachea
                              //para que se cargue mas rapido
                              child: ListTile(
                                leading: CachedNetworkImage(
                                  imageUrl: imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.values[0],
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    //En caso de que no cargue la imagen se muestra la pokeball
                                    'assets/images/pokeball.png',
                                    fit: BoxFit.cover,
                                  ),
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
                      //TextFormField para agregar comentarios
                      //que no tiene funcionalidad de momento mas que estetico
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
                        style: const TextStyle(color: Colors.black),
                        controller: _controller,
                        decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.black),
                            labelText: 'Insert Comment',
                            border: OutlineInputBorder(),
                            fillColor: Colors.white70,
                            filled: true),
                      ),
                      const SizedBox(height: 16),
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
