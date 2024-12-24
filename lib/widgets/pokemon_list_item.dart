import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PokemonListItem extends StatelessWidget {
  final String pokemonName;
  final String imageUrl;
  final bool isHiddenAbility;
  final bool isTapped;
  final VoidCallback onTap;
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  final VoidCallback onTapCancel;

  const PokemonListItem({
    Key? key,
    required this.pokemonName,
    required this.imageUrl,
    required this.isHiddenAbility,
    required this.isTapped,
    required this.onTap,
    required this.onTapDown,
    required this.onTapUp,
    required this.onTapCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapCancel,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: isTapped
              ? const Color.fromARGB(255, 141, 153, 174)
              : const Color.fromARGB(255, 43, 45, 66),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: Image.network(
            imageUrl,
            width: 50,
            height: 50,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/pokeball.png',
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              );
            },
          ),
          title: Text(
            pokemonName.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 237, 242, 244),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Visibility(
                visible: isHiddenAbility,
                child: const Text(
                  'Hidden ability',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color.fromARGB(255, 237, 242, 244),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
