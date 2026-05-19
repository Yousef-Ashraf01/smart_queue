import 'package:flutter/material.dart';

class TipRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const TipRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color.fromARGB(255, 11, 58, 30)),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 11, 58, 30),
            ),
          ),
        ),
      ],
    );
  }
}
