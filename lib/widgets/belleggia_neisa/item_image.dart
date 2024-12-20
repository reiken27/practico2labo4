import 'package:flutter/material.dart';

class ItemImage extends StatelessWidget {
  final String? imageUrl;

  const ItemImage({super.key, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return imageUrl != null
        ? Center(
            child: Image.network(
              imageUrl!,
              width: 80,
              height: 80,
              fit: BoxFit.contain,
            ),
          )
        : const SizedBox.shrink();
  }
}
