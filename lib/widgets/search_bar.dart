import 'package:flutter/material.dart';

class PokemonSearchBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSearchChanged;

  const PokemonSearchBar({
    super.key,
    required this.searchController,
    required this.onClearSearch,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Buscar Pokemon...',
          prefixIcon: const Icon(Icons.search, color: Colors.blue),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, color: Colors.blue),
            onPressed: onClearSearch,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: Colors.blue),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}
