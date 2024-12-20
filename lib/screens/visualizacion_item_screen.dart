import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:practico2labo4/models/model_item.dart'; 
import 'package:practico2labo4/widgets/belleggia_neisa/comments_section.dart';
import 'package:practico2labo4/widgets/belleggia_neisa/detail_row.dart';
import 'package:practico2labo4/widgets/belleggia_neisa/favorite_button.dart';
import 'package:practico2labo4/widgets/belleggia_neisa/generations_list.dart';
import 'package:practico2labo4/widgets/belleggia_neisa/item_image.dart';
import 'package:practico2labo4/widgets/belleggia_neisa/section_title.dart';

class VisualizacionItemScreen extends StatefulWidget {
  final String url;
  const VisualizacionItemScreen({super.key, required this.url});

  @override
  State<VisualizacionItemScreen> createState() =>
      _VisualizacionItemScreenState();
}

class _VisualizacionItemScreenState extends State<VisualizacionItemScreen> {
  Item? item;
  bool isFavorite = false;
  Map<String, bool> favoriteItems = {};
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadFavorites();
    fetchItem();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('favoriteItems', json.encode(favoriteItems));
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final storedFavorites = prefs.getString('favoriteItems');
    if (storedFavorites != null) {
      setState(() {
        favoriteItems = Map<String, bool>.from(json.decode(storedFavorites));
      });
    }
  }

  Future<void> fetchItem() async {
    try {
      final response = await http.get(Uri.parse(widget.url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          item = Item.fromJson(data);
        });
      } else {
        throw Exception('Error al cargar el item: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al cargar el item: $e');
      setState(() {
        item = null;
      });
    }
  }

  void enviarComentario() {
    final comentario = _controller.text;
    if (comentario.isNotEmpty) {
      print('Comentario enviado: $comentario');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario enviado con éxito')),
      );
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese un comentario')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detalles del Item',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: item == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withOpacity(0.9),
                        Colors.yellow.withOpacity(0.9),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
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
                      if (item?.sprites?.spritesDefault != null)
                        Center(
                          child: ItemImage(imageUrl: item!.sprites!.spritesDefault),
                        ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          item?.name?.toUpperCase() ?? 'Desconocido',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 115, 255),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (item?.category?.name != null)
                        DetailRow(
                          label: 'Categoría',
                          value: item?.category?.name,
                        ),
                      const SizedBox(height: 24),
                      const SectionTitle(title: 'DETALLES DESTACADOS'),
                      const SizedBox(height: 8),
                      if (item?.effectEntries != null &&
                          item!.effectEntries!.isNotEmpty)
                        DetailRow(
                          label: 'Efecto',
                          value: item?.effectEntries?.first.effect,
                        ),
                      const SizedBox(height: 16),
                      const SectionTitle(title: 'GENERACIONES DE JUEGO EN LAS QUE APARECE EL ÍTEM'),
                      const SizedBox(height: 8),
                      GenerationsList(gameIndices: item?.gameIndices),
                      const SizedBox(height: 24),
                      const SectionTitle(title: 'COMENTARIOS Y FAVORITOS'),
                      const SizedBox(height: 8),
                      CommentsSection(
                        controller: _controller,
                        onSubmit: enviarComentario,
                      ),
                      const SizedBox(height: 24),
                      FavoriteButton(
                        isFavorite: favoriteItems[item?.name] ?? false,
                        onPressed: () {
                          setState(() {
                            favoriteItems[item?.name ?? ''] =
                                !(favoriteItems[item?.name ?? ''] ?? false);
                            saveFavorites();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
