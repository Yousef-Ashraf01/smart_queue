import 'package:flutter/material.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const CircleButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final ext = context.appTheme;

    final bgColor = isDark ? ext.cardColor.withOpacity(0.9) : Colors.white.withOpacity(0.9);
    final borderColor = isDark ? ext.cardBorder : const Color(0xFF10B981).withOpacity(0.15);
    final shadowColor = isDark ? Colors.transparent : Colors.black.withOpacity(0.04);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
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
        child: Center(child: child),
      ),
    );
  }
}
