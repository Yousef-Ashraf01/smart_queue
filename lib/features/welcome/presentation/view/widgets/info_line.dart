import 'package:flutter/material.dart';

class InfoLine extends StatelessWidget {
  final double widthFraction;

  const InfoLine({super.key, required this.widthFraction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth * widthFraction,
          height: 6,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 118, 226, 136).withOpacity(0.5),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }
}
