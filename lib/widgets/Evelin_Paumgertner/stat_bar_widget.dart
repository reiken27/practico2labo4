import 'package:flutter/material.dart';

class StatBarWidget extends StatelessWidget {
  final String label;
  final int value;
  final int maxStat;

  const StatBarWidget({
    super.key,
    required this.label,
    required this.value,
    this.maxStat = 300,
  });

  @override
  Widget build(BuildContext context) {
    Color barColor;

    switch (label) {
      case 'HP':
        barColor = Colors.redAccent;
        break;
      case 'ATK':
        barColor = Colors.blueAccent;
        break;
      case 'DEF':
        barColor = Colors.pinkAccent;
        break;
      case 'SPD':
        barColor = Colors.greenAccent;
        break;
      case 'EXP':
        barColor = Colors.lightBlueAccent;
        break;
      default:
        barColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: (value / maxStat).clamp(0.0, 1.0),
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: barColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$value/$maxStat',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
