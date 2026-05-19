import 'package:flutter/material.dart';

class StepLine extends StatelessWidget {
  final bool isActive;

  const StepLine({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Container(
        width: 48,
        height: 1.5,
        color:
            isActive
                ? const Color.fromARGB(255, 11, 58, 30)
                : const Color(0xFFB2D8DF),
      ),
    );
  }
}
