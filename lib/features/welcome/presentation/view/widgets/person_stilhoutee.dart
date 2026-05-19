import 'package:flutter/material.dart';

class PersonSilhouette extends StatelessWidget {
  final double size;
  final double opacity;

  const PersonSilhouette({
    super.key,
    required this.size,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: size * 0.22,
          backgroundColor: const Color.fromARGB(
            255,
            118,
            226,
            136,
          ).withOpacity(opacity),
        ),
        const SizedBox(height: 3),
        Container(
          width: size * 0.44,
          height: size * 0.55,
          decoration: BoxDecoration(
            color: const Color.fromARGB(
              255,
              118,
              226,
              136,
            ).withOpacity(opacity),
            borderRadius: BorderRadius.circular(size * 0.1),
          ),
        ),
      ],
    );
  }
}
