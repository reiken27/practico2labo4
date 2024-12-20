import 'package:flutter/material.dart';
import 'package:practico2labo4/models/model_movimientos.dart';
import 'detail_row.dart';

class DetailsSection extends StatelessWidget {
  final bool isDarkMode;
  final Move? moveData;
  final String? pokemonImageUrl;

  const DetailsSection({
    required this.isDarkMode,
    required this.moveData,
    required this.pokemonImageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: pokemonImageUrl != null
            ? DecorationImage(
                image: NetworkImage(pokemonImageUrl!),
                fit: BoxFit.cover,
              )
            : const DecorationImage(
                image: AssetImage('assets/images/pokemondetalle.jpg'),
                fit: BoxFit.cover,
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Detalles Destacados',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.lightBlue : Colors.teal,
            ),
          ),
          const SizedBox(height: 16),
          if (moveData?.power != null)
            DetailRow(label: 'Poder', value: '${moveData?.power}'),
          if (moveData?.accuracy != null)
            DetailRow(label: 'Precisión', value: '${moveData?.accuracy}'),
          if (moveData?.pp != null)
            DetailRow(label: 'PP', value: '${moveData?.pp}'),
          if (moveData?.effectEntries != null &&
              moveData!.effectEntries!.isNotEmpty)
            DetailRow(
              label: 'Efecto',
              value: '${moveData?.effectEntries?[0].effect}',
            ),
        ],
      ),
    );
  }
}
