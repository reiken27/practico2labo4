import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/models/model_pokemon.dart';
import 'package:practico2labo4/models/model_evolution_chain.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practico2labo4/widgets/Evelin_Paumgertner/detail_row_widget.dart';
import 'package:practico2labo4/widgets/Evelin_Paumgertner/stat_bar_widget.dart';


class VisualizacionPokemonidScreen extends StatefulWidget {
  final String url;
  const VisualizacionPokemonidScreen({super.key, required this.url});

  @override
  State<VisualizacionPokemonidScreen> createState() =>
      _VisualizacionPokemonidScreenState();
}

class _VisualizacionPokemonidScreenState
    extends State<VisualizacionPokemonidScreen> {
  Pokemon? pokemon;
  ModelEvolutionChain? evolutionChain;
  bool isFavorite = false;
  final TextEditingController _controller = TextEditingController();
  final apiImageUrl = dotenv.env['API_ARTWORK_URL'];

  Future<void> _loadPokemonData() async {
    if (pokemon?.id == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool('isFavorite_${pokemon?.id}') ?? false;
      _controller.text = prefs.getString('comment_${pokemon?.id}') ?? '';
    });
  }

  Future<void> _saveFavoriteStatus() async {
    if (pokemon?.id == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFavorite_${pokemon?.id}', isFavorite);
  }

  Future<void> _saveComment(String comment) async {
    if (pokemon?.id == null) return;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('comment_${pokemon?.id}', comment);
  }

  @override
  void initState() {
    super.initState();
    fetchPokemon();
    _loadPokemonData();
  }

  Future<void> fetchPokemon() async {
    final response = await http.get(Uri.parse(widget.url));
    if (response.statusCode == 200) {
      setState(() {
        pokemon = Pokemon.fromJson(json.decode(response.body));
      });
      fetchEvolutionChain(); 
      _loadPokemonData();
    } else {
      throw Exception('Error al cargar el Pokémon');
    }
  }

  Future<void> fetchEvolutionChain() async {
    if (pokemon?.species?.url == null) return;

    final speciesResponse = await http.get(Uri.parse(pokemon!.species!.url!));
    if (speciesResponse.statusCode == 200) {
      final speciesData = json.decode(speciesResponse.body);
      final evolutionUrl = speciesData['evolution_chain']['url'];
      if (evolutionUrl != null) {
        final evolutionResponse = await http.get(Uri.parse(evolutionUrl));
        if (evolutionResponse.statusCode == 200) {
          setState(() {
            evolutionChain =
                ModelEvolutionChain.fromJson(json.decode(evolutionResponse.body));
          });
        }
      }
    }
  }  Color getColorForType(String type) {
    switch (type.toLowerCase()) {
       case 'normal':
        return const Color.fromARGB(255, 168, 167, 122);
      case 'fighting':
        return const Color.fromARGB(255, 222, 110, 110);
      case 'flying':
        return const Color.fromARGB(255, 169, 143, 243);
      case 'poison':
        return const Color.fromARGB(255, 214, 96, 212);
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
        return const Color.fromARGB(255, 233, 157, 95);
      case 'water':
        return const Color.fromARGB(255, 99, 144, 240);
      case 'grass':
        return const Color.fromARGB(255, 122, 199, 76);
      case 'electric':
        return const Color.fromARGB(255, 189, 173, 69);
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
      backgroundColor: const Color.fromARGB(255, 121, 199, 248),
      foregroundColor: Colors.white,
    ),
    body: pokemon == null
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: getColorForType(pokemon!.types![0].type?.name ?? ''),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: Image.network(
                          pokemon!.sprites?.other!.home?.frontDefault ?? '',
                          height: 250,
                          width: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        left: 8,
                        top: 8,
                        child: Text(
                          '#${pokemon?.id.toString().padLeft(3, '0')}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 8,
                        top: 8,
                        child: Text(
                          pokemon?.name?.toUpperCase() ?? '',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

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
                        DetailRowWidget(title: 'Altura', value: '${pokemon!.height! / 10} m'),
                        DetailRowWidget(title: 'Peso', value: '${pokemon!.weight! / 10} kg'),
                        DetailRowWidget(title: 'Tipo', value: getPokemonTypes()),
                        DetailRowWidget(title: 'Habilidades', value: getPokemonAbilities()),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Estadísticas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StatBarWidget(label: 'HP', value: pokemon!.stats?[0].baseStat ?? 0, maxStat: 100),
                  StatBarWidget(label: 'ATK', value: pokemon!.stats!.length > 1 ? pokemon!.stats![1].baseStat ?? 0 : 0, maxStat: 100),
                  StatBarWidget(label: 'DEF', value: pokemon!.stats!.length > 2 ? pokemon!.stats![2].baseStat ?? 0 : 0, maxStat: 100),

                  StatBarWidget(
                    label: 'SPD',
                    value: pokemon!.stats != null && pokemon!.stats!.length > 5
                        ? pokemon!.stats![5].baseStat ?? 0
                        : 0,
                    maxStat: 100,
                  ),
                  StatBarWidget(label: 'EXP', value: pokemon!.baseExperience ?? 0, maxStat: 1000),


                  const SizedBox(height: 20),

                  buildEvolutionChain(),

                  const SizedBox(height: 20),

                  const Text(
                    'Comentarios',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _controller,
                    onChanged: (value) {
                      _saveComment(value);
                    },
                    decoration: const InputDecoration(
                      hintText: 'Ingresa un comentario',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                          width: 1.0,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Guardado en Pokedex',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Switch(
                        value: isFavorite,
                        onChanged: (value) {
                          setState(() {
                            isFavorite = value;
                          });
                          _saveFavoriteStatus();
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


Widget buildEvolutionChain() {
  if (evolutionChain == null || evolutionChain!.chain == null) {
    return const Text(
      'No hay información de evolución disponible',
      style: TextStyle(fontSize: 16),
    );
  }



  List<Chain> evolutionSteps = [];
  Chain? current = evolutionChain!.chain;
  while (current != null) {
    evolutionSteps.add(current);
    current = current.evolvesTo!.isNotEmpty ? current.evolvesTo?.first : null;
  }

  return Container(
    margin: const EdgeInsets.all(3.0),
    padding: const EdgeInsets.all(16.0),
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
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: List.generate(evolutionSteps.length - 1, (index) {
            final current = evolutionSteps[index];
            final next = evolutionSteps[index + 1];

            final currentImageUrl =
                '$apiImageUrl${current.species!.url!.split('/')[6]}.png';
            final nextImageUrl =
                '$apiImageUrl${next.species!.url!.split('/')[6]}.png';

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Image.network(
                          currentImageUrl,
                          height: 130,
                          width: 130,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          current.species!.name!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.arrow_forward,
                        size: 24, color: Colors.black),
                    const SizedBox(width: 10),
                    Column(
                      children: [
                        Image.network(
                          nextImageUrl,
                          height: 130,
                          width: 130,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          next.species!.name!.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (index < evolutionSteps.length - 2)
                  const SizedBox(height: 20),
              ],
            );
          }),
        ),
      ],
    ),
  );
}




String getPokemonTypes() {
  if (pokemon?.types != null && pokemon!.types!.isNotEmpty) {
   
    return pokemon!.types!
        .map((type) => type.type?.name ?? 'N/A')
        .join(', ');
  }
  return 'N/A'; 
}

String getPokemonAbilities() {
  if (pokemon?.abilities != null && pokemon!.abilities!.isNotEmpty) {
    
    return pokemon!.abilities!
        .map((ability) => ability.ability?.name ?? 'N/A')
        .join(', ');
  }
  return 'N/A'; 
}
}


