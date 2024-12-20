import 'package:flutter/material.dart';

class StatBarWidget extends StatelessWidget {
  final String label;
  final int value;
  final int maxStat;
  final Color barColor;

  const StatBarWidget({
    super.key,
    required this.label,
    required this.value,
    this.maxStat = 300,
    this.barColor = Colors.grey, required int maxValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: value / maxStat,
          color: barColor,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
