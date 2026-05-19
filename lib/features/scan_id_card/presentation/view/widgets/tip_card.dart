import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class TipCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const TipCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.tealSubtle.withOpacity(0.7)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.teal),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                color: AppColors.tealMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
