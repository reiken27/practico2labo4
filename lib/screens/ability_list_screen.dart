import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/screens.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbilityListScreen extends StatefulWidget {
  const AbilityListScreen({super.key});

  @override
  State<AbilityListScreen> createState() => _AbilityListScreenState();
}

class _AbilityListScreenState extends State<AbilityListScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> abilitys = [];
  List<dynamic> filteredAbility = [];
  Map<String, bool> favoriteAbilities = {}; // Mapa para favoritos
  bool isLoading = false;
  String? nextUrl;
  bool isDisposed = false;
  int? tappedAbilityIndex; // Para guardar el índice del elemento presionado

  @override
  void initState() {
    super.initState();
    final apiUrl = dotenv.env['API_URL'];
    fetchAbility('$apiUrl/ability');
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAbility(String url, {int retries = 3}) async {
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
            abilitys.addAll(data['results']);
            filteredAbility = List.from(abilitys);
            nextUrl = data['next'];
            isLoading = false;
          });
        }

        if (nextUrl != null && !isDisposed) {
          fetchAbility(nextUrl!);
        }
      } else {
        throw Exception('Error al cargar las habilidades');
      }
    } on TimeoutException catch (_) {
      if (retries > 0) {
        fetchAbility(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception(
            'Tiempo de espera agotado. No se pudo conectar a la API.');
      }
    } on http.ClientException catch (_) {
      if (retries > 0) {
        fetchAbility(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error de conexión. Verifica tu red o la API.');
      }
    }
  }

  void filterAbility(String query) {
    setState(() {
      filteredAbility = abilitys
          .where((ability) =>
              ability['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    searchController.clear();
    filterAbility('');
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
    loadFavorites();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ability List'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 43, 45, 66),
      ),
      //Barra de busqueda
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search ability...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: filterAbility,
            ),
          ),
          Expanded(
            child: isLoading && abilitys.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredAbility.length,
                    itemBuilder: (context, index) {
                      final ability = filteredAbility[index];
                      //Lista de habilidades
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AbilityListItem(
                                url: ability['url'],
                              ),
                            ),
                          );
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        //Cuando se mantiene precionado
                        //cambia el color de fondo
                        onTapDown: (_) {
                          setState(() {
                            tappedAbilityIndex =
                                index; // Guardar índice del presionado
                          });
                        },
                        onTapUp: (_) {
                          setState(() {
                            tappedAbilityIndex = null; // Resetear al soltar
                          });
                        },
                        onTapCancel: () {
                          setState(() {
                            tappedAbilityIndex = null; // Resetear si cancela
                          });
                        },
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tappedAbilityIndex == index
                                ? const Color.fromARGB(
                                    255, 141, 153, 174) // Color presionado
                                : const Color.fromARGB(
                                    255, 43, 45, 66), // Color normal
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 8,
                                spreadRadius: 2,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          //El nombre de la habilidad
                          child: ListTile(
                            title: Text(
                              ability['name'].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 237, 242, 244),
                              ),
                            ),
                            //El icono de favoritos
                            //Al tocarlo cambia de color
                            //y se guarda la shared_preferences
                            trailing: IconButton(
                              icon: Icon(
                                favoriteAbilities[ability['name']] == true
                                    ? Icons.star // Estrella llena
                                    : Icons.star_border, // Estrella vacía
                                color: favoriteAbilities[ability['name']] ==
                                        true
                                    ? Colors.yellow
                                    : const Color.fromARGB(255, 237, 242, 244),
                              ),
                              onPressed: () {
                                setState(() {
                                  favoriteAbilities[ability['name']] =
                                      !(favoriteAbilities[ability['name']] ??
                                          false);
                                });
                                saveFavorites(); // Guarda los favoritos
                              },
                            ),
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
