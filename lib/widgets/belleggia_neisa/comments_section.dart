import 'package:flutter/material.dart';

class CommentsSection extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSubmit;

  const CommentsSection({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Ingresa un comentario',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            textStyle: const TextStyle(fontSize: 18),
          ),
          child: const Text('Enviar Comentario'),
        ),
      ],
    );
  }
}
