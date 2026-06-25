import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const TipCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF10B981);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.85),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: activeColor.withOpacity(0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: activeColor.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 16,
                color: activeColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1D4E),
                height: 1.2,
                fontFamily: 'Inter Tight',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
