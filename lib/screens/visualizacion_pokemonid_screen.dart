import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VisualizacionPokemonidScreen extends StatefulWidget {
  final String url;
  const VisualizacionPokemonidScreen({super.key, required this.url});

  @override
  State<VisualizacionPokemonidScreen> createState() =>
      _VisualizacionPokemonidScreenState();
}

class _VisualizacionPokemonidScreenState
    extends State<VisualizacionPokemonidScreen> {
  Map<String, dynamic>? pokemon;
  bool isFavorite = false;
  final TextEditingController _controller = TextEditingController();
  


  @override
  void initState() {
    super.initState();
    fetchPokemon();
  }

  Future<void> fetchPokemon() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        pokemon = json.decode(response.body);
      });
    } else {
      throw Exception('Error al cargar el Pokémon');
    }
  }

  Future<List<Map<String, String>>> fetchEvolutionChain() async {
  final speciesResponse =
      await http.get(Uri.parse(pokemon?['species']['url']));
  if (speciesResponse.statusCode == 200) {
    final speciesData = json.decode(speciesResponse.body);
    final evolutionUrl = speciesData['evolution_chain']['url'];
    final evolutionResponse = await http.get(Uri.parse(evolutionUrl));
    if (evolutionResponse.statusCode == 200) {
      final evolutionData = json.decode(evolutionResponse.body);

      // Recorre la cadena de evoluciones
      List<Map<String, String>> evolutions = [];
      var current = evolutionData['chain'];
      while (current != null) {
        final name = current['species']['name'];
        final id = current['species']['url']
            .split('/')[6]; 
        evolutions.add({
          'name': name,
          'image': 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png'
        });
        current = current['evolves_to']?.isNotEmpty == true
            ? current['evolves_to'][0]
            : null;
      }
      return evolutions;
    }
  }
  return [];
}


  Color getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'normal':
        return const Color.fromARGB(255, 168, 167, 122);
      case 'fighting':
        return const Color.fromARGB(255, 194, 104, 101);
      case 'flying':
        return const Color.fromARGB(255, 169, 143, 243);
      case 'poison':
        return const Color.fromARGB(255, 163, 62, 161);
      case 'ground':
        return const Color.fromARGB(255, 226, 191, 101);
      case 'rock':
        return const Color.fromARGB(255, 182, 161, 54);
      case 'bug':
        return const Color.fromARGB(255, 166, 185, 26);
      case 'ghost':
        return const Color.fromARGB(255, 115, 87, 151);
      case 'steel':
        return const Color.fromARGB(255, 183, 183, 206);
      case 'fire':
        return const Color.fromARGB(255, 238, 129, 48);
      case 'water':
        return const Color.fromARGB(255, 99, 144, 240);
      case 'grass':
        return const Color.fromARGB(255, 122, 199, 76);
      case 'electric':
        return const Color.fromARGB(255, 247, 208, 44);
      case 'psychic':
        return const Color.fromARGB(255, 249, 85, 135);
      case 'ice':
        return const Color.fromARGB(255, 150, 217, 214);
      case 'dragon':
        return const Color.fromARGB(255, 111, 53, 252);
      case 'dark':
        return const Color.fromARGB(255, 112, 87, 70);
      case 'fairy':
        return const Color.fromARGB(255, 214, 133, 173);
      case 'unknown':
        return const Color.fromARGB(255, 190, 190, 190);
      case 'stellar':
        return const Color.fromARGB(255, 0, 128, 128);
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Pokémon'),
      ),
      body: pokemon == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: getColorForType(pokemon?['types'][0]['type']['name']),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagen, ID y nombre del Pokémon
                    Stack(
                      children: [
                        Center(
                          child: Image.network(
                            pokemon?['sprites']['other']['home']
                                    ['front_default'] ??
                                '',
                            height: 250,
                            width: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Positioned(
                          left: 8,
                          top: 8,
                          child: Text(
                            '#${pokemon?['id'].toString().padLeft(3, '0')}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Text(
                            pokemon?['name']?.toUpperCase() ?? '',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Datos principales
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildDetailRow('Altura', '${pokemon?['height'] / 10} m'),
                          buildDetailRow('Peso', '${pokemon?['weight'] / 10} kg'),
                          buildDetailRow('Tipo', getPokemonTypes()),
                          buildDetailRow('Habilidades', getPokemonAbilities()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Estadísticas
                    const Text(
                      'Estadísticas',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    buildStatBar('HP', pokemon?['stats'][0]['base_stat']),
                    buildStatBar('ATK', pokemon?['stats'][1]['base_stat']),
                    buildStatBar('DEF', pokemon?['stats'][2]['base_stat']),
                    buildStatBar('SPD', pokemon?['stats'][5]['base_stat']),
                    buildStatBar('EXP', pokemon?['base_experience'], maxStat: 1000),
                    const SizedBox(height: 20),
                    buildEvolutionChain(),
                    const SizedBox(height: 20),
                    // Comentarios y boton guardar
                    const Text(
                      'Comentarios',
                      style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // comentario
                    TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Ingresa un comentario',
                      border:  OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 0, 0, 0), // Cambia este color al que desees
                          width: 2.0, // Puedes cambiar el grosor si lo deseas
                        ),
                      ),
                      enabledBorder:  OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255), // Cambia este color al que desees
                          width: 1.0, // Puedes cambiar el grosor si lo deseas
                        ),
                      ),
                    ),
                  ),

                    const SizedBox(height: 16),

                    // Switch para marcar como "Guardado en Pokédex"
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Guardado en Pokedex',
                          style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,),
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

                    
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatBar(String label, int? value, {int maxStat = 300}) {
    Color barColor;

    switch (label) {
      case 'HP':
        barColor = Colors.redAccent;
        break;
      case 'ATK':
        barColor = Colors.blueAccent;
        break;
      case 'DEF':
        barColor = Colors.pinkAccent;
        break;
      case 'SPD':
        barColor = Colors.greenAccent;
        break;
      case 'EXP':
        barColor = Colors.lightBlueAccent;
        break;
      default:
        barColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          // Etiqueta
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          // Barra
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (value ?? 0) / maxStat,
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${value ?? 0}/$maxStat',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

Widget buildEvolutionChain() {
  return FutureBuilder<List<Map<String, String>>>(
    future: fetchEvolutionChain(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
        return const Text(
          'No hay información de evolución disponible',
          style: TextStyle(fontSize: 16),
        );
      }

      final evolutions = snapshot.data!;
      
      return Container(
        margin: const EdgeInsets.all(3.0), // Espaciado externo
        padding: const EdgeInsets.all(16.0), // Espaciado interno
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12.0), 
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), 
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), 
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Evoluciones',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(evolutions.length - 1, (index) {
                final current = evolutions[index];
                final next = evolutions[index + 1];

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Image.network(
                              current['image']!,
                              height: 130,
                              width: 130,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              current['name']!.toUpperCase(),
                              style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        const Icon(Icons.arrow_forward, size: 24),
                        const SizedBox(width: 10),
                        Column(
                          children: [
                            Image.network(
                              next['image']!,
                              height: 130,
                              width: 130,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              next['name']!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 14, 
                                fontWeight: FontWeight.bold,),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (index < evolutions.length - 2) const SizedBox(height: 20),
                  ],
                );
              }),
            ),
          ],
        ),
      );
    },
  );
}



  String getPokemonTypes() {
    List<dynamic>? types = pokemon?['types'];
    if (types != null && types.isNotEmpty) {
      return types.map((type) => type['type']['name']).join(', ');
    }
    return 'N/A';
  }

  String getPokemonAbilities() {
    List<dynamic>? abilities = pokemon?['abilities'];
    if (abilities != null && abilities.isNotEmpty) {
      return abilities.map((ability) => ability['ability']['name']).join(', ');
    }
    return 'N/A';
  }
}
