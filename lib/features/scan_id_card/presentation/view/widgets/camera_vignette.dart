import 'package:flutter/material.dart';

class CameraVignette extends StatelessWidget {
  const CameraVignette({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.2,
            colors: [Colors.transparent, Colors.black.withOpacity(0.45)],
          ),
        ),
      ),
    );
  }
}
