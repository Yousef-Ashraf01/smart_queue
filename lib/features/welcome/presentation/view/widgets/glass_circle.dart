import 'package:flutter/material.dart';

class GlassCircle extends StatelessWidget {
  final double size;
  final double opacity;

  const GlassCircle({super.key, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
      ),
    );
  }
}
