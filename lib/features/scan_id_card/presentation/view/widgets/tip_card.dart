import 'package:flutter/material.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class TipCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const TipCard({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;

    final activeColor = isDark ? Colors.green[300]! : const Color(0xFF10B981);
    final bgColor = isDark ? ext.cardColor.withOpacity(0.85) : Colors.white.withOpacity(0.85);
    final borderColor = isDark ? ext.cardBorder : activeColor.withOpacity(0.15);
    final shadowColor = isDark ? Colors.transparent : Colors.black.withOpacity(0.03);
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
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
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: textColor,
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
