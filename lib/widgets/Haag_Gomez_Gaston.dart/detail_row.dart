import 'package:flutter/material.dart';

class DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const DetailRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: isDarkMode
                  ? Colors.lightBlue
                  : const Color.fromARGB(255, 236, 3, 3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                color: isDarkMode
                    ? const Color.fromARGB(248, 224, 6, 6)
                    : const Color.fromARGB(221, 3, 24, 139),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
