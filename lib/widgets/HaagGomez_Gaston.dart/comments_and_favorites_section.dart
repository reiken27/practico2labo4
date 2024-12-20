import 'package:flutter/material.dart';

class CommentsAndFavoritesSection extends StatelessWidget {
  final Color favoriteTextColor;
  final Color commentTextColor;
  final Color inputBorderColor;
  final bool isFavorite;
  final Function(bool) onFavoriteChanged;
  final TextEditingController controller;

  const CommentsAndFavoritesSection({
    required this.favoriteTextColor,
    required this.commentTextColor,
    required this.inputBorderColor,
    required this.isFavorite,
    required this.onFavoriteChanged,
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Comentarios y Favoritos',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: commentTextColor,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: 'Ingresa un comentario',
            labelStyle: TextStyle(color: commentTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: inputBorderColor),
            ),
          ),
          style: TextStyle(
            color: isDarkMode
                ? const Color.fromARGB(255, 148, 3, 3)
                : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Es favorito:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: favoriteTextColor,
              ),
            ),
            Switch(
              value: isFavorite,
              onChanged: onFavoriteChanged,
            ),
          ],
        ),
      ],
    );
  }
}
