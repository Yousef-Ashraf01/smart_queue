import 'package:flutter/material.dart';

class StepCircle extends StatelessWidget {
  final int number;
  final String label;
  final bool isActive;

  const StepCircle({
    super.key,
    required this.number,
    required this.label,
    required this.isActive,
  });

  static const _activeColor = Color.fromARGB(255, 11, 58, 30);
  static const _inactiveColor = Color(0xFF6B8E96);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: isActive ? _activeColor : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: isActive ? _activeColor : _inactiveColor,
              width: 1.8,
            ),
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : _inactiveColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? _activeColor : _inactiveColor,
          ),
        ),
      ],
    );
  }
}
