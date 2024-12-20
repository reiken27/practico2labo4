import 'package:flutter/material.dart';
import 'package:practico2labo4/models/model_item.dart';

class GenerationsList extends StatelessWidget {
  final List<GameIndex>? gameIndices;

  const GenerationsList({super.key, this.gameIndices});

  @override
  Widget build(BuildContext context) {
    if (gameIndices == null || gameIndices!.isEmpty) {
      return const Text(
        'No hay información de generaciones para este ítem.',
        style: TextStyle(fontSize: 18, color: Colors.black),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: gameIndices!.map((game) {
        if (game.generation?.name != null && game.gameIndex != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              '${game.generation!.name!.toUpperCase()} | GAME INDEX: ${game.gameIndex}',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          );
        } else {
          return const Text(
            'Datos incompletos para uno de los juegos.',
            style: TextStyle(fontSize: 16, color: Colors.black),
          );
        }
      }).toList(),
    );
  }
}
