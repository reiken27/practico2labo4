import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/screens.dart';

class ListaPokemonScreen extends StatefulWidget {
  const ListaPokemonScreen({super.key});

  @override
  State<ListaPokemonScreen> createState() => _ListaPokemonScreenState();
}

class _ListaPokemonScreenState extends State<ListaPokemonScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> pokemons = [];
  List<dynamic> filteredPokemon = [];
  bool isLoading = false;
  String? nextUrl;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchPokemon('https://pokeapi.co/api/v2/pokemon');
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchPokemon(String url, {int retries = 3}) async {
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
            pokemons.addAll(data['results']);
            filteredPokemon = List.from(pokemons);
            nextUrl = data['next'];
            isLoading = false;
          });
        }

        if (nextUrl != null && !isDisposed) {
          fetchPokemon(nextUrl!);
        }
      } else {
        throw Exception('Error al cargar la lista de pokemon');
      }
    } on TimeoutException catch (_) {
      if (retries > 0) {
        fetchPokemon(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception(
            'Tiempo de espera agotado. No se pudo conectar a la API.');
      }
    } on http.ClientException catch (_) {
      if (retries > 0) {
        fetchPokemon(url, retries: retries - 1);
      } else {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error de conexión. Verifica tu conexion.');
      }
    }
  }

  void filterPokemon(String query) {
    setState(() {
      filteredPokemon = pokemons
          .where((pokemon) =>
              pokemon['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    searchController.clear();
    filterPokemon('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokemon'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar Pokemon...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: filterPokemon,
            ),
          ),
          Expanded(
            child: isLoading && pokemons.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredPokemon.length,
                    itemBuilder: (context, index) {
                      final pokemon = filteredPokemon[index];

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
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
                            pokemon['name'].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.black54),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    VisualizacionPokemonScreen(
                                  url: pokemon['url'],
                                ),
                              ),
                            );
                          },
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
