import 'package:flutter/material.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class TipRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const TipRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final greenColor = isDark ? Colors.green[300]! : const Color.fromARGB(255, 11, 58, 30);

    return Row(
      children: [
        Icon(icon, size: 16, color: greenColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: greenColor,
            ),
          ),
        ),
      ],
    );
  }
}
