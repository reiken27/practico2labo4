import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:practico2labo4/screens/screens.dart';
import 'package:practico2labo4/screens/visualizacion_item_screen.dart';

class ListaItemsScreen extends StatefulWidget {
  const ListaItemsScreen({super.key});

  @override
  State<ListaItemsScreen> createState() => _ListaItemsScreenState();
}

class _ListaItemsScreenState extends State<ListaItemsScreen> {
  final TextEditingController searchController = TextEditingController();
  List<dynamic> items = [];
  List<dynamic> filteredItems = [];
  bool isLoading = false;
  String? nextUrl;
  bool isDisposed = false;

  @override
  void initState() {
    super.initState();
    fetchItems('https://pokeapi.co/api/v2/item');
  }

  @override
  void dispose() {
    isDisposed = true;
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchItems(String url, {int retries = 3}) async {
    if (isDisposed) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (!isDisposed) {
          for (var item in data['results']) {
            final imageUrl = await fetchItemImage(item['url']);
            item['imageUrl'] = imageUrl;
          }

          if (!isDisposed) {
            setState(() {
              items.addAll(data['results']);
              filteredItems = List.from(items);
              nextUrl = data['next'];
              isLoading = false;
            });
          }
        }

        if (nextUrl != null && !isDisposed) {
          await fetchItems(nextUrl!);
        }
      } else {
        throw Exception('Error al cargar los items');
      }
    } on TimeoutException catch (_) {
      if (retries > 0 && !isDisposed) {
        await fetchItems(url, retries: retries - 1);
      } else if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
        throw Exception(
            'Tiempo de espera agotado. No se pudo conectar a la API.');
      }
    } on http.ClientException catch (_) {
      if (retries > 0 && !isDisposed) {
        await fetchItems(url, retries: retries - 1);
      } else if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
        throw Exception('Error de conexión. Verifica tu red o la API.');
      }
    } finally {
      if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<String> fetchItemImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['sprites']['default'] ?? '';
    } else {
      throw Exception('Error al cargar la imagen del item');
    }
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) =>
              item['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void clearSearch() {
    searchController.clear();
    filterItems('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Items',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar items...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: clearSearch,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onChanged: filterItems,
            ),
          ),
          Expanded(
            child: isLoading && items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      String imageUrl = item['imageUrl'] ?? '';

                      return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Colors.orange,
                              Colors.yellow,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 71, 119, 250)
                                  .withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(4, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          leading: imageUrl.isEmpty
                              ? const CircularProgressIndicator()
                              : Image.network(
                                  imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                          title: Text(
                            '${index + 1} - ${item['name'].toUpperCase()}',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 71, 119, 250),
                            ),
                          ),
                          subtitle: const Text(
                            'Ingresa para más detalles',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                              color: Colors.black54,
                            ),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Colors.black54),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisualizacionItemScreen(
                                  url: item['url'],
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
