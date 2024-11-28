import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/screens.dart';

class AbilityListScreen extends StatefulWidget {
  const AbilityListScreen({super.key});

  @override
  State<AbilityListScreen> createState() => _AbilityListScreenState();
}

class _AbilityListScreenState extends State<AbilityListScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> abilitys = [];
  List<dynamic> filteredAbility = [];
  bool isLoading = false;
  String? nextUrl;
  bool isDisposed = false;
  int? tappedAbilityIndex; // Para guardar el índice del elemento presionado

  @override
  void initState() {
    super.initState();
    fetchAbility('https://pokeapi.co/api/v2/ability');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ability List'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 43, 45, 66),
      ),
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
                        highlightColor: Colors
                            .transparent, // Eliminar el "highlight" al presionar
                        splashColor:
                            Colors.transparent, // Eliminar el efecto "splash"
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
                          child: ListTile(
                            title: Text(
                              ability['name'].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 237, 242, 244),
                              ),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                color: Color.fromARGB(255, 237, 242, 244)),
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
