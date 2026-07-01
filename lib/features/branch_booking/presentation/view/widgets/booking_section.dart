import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

class BookingSection extends StatelessWidget {
  final String title;
  final Widget child;
  final int stepNumber;
  final bool isLast;

  const BookingSection({
    super.key,
    required this.title,
    required this.child,
    required this.stepNumber,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final teal = isDark ? Colors.green[400]! : AppColors.teal;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Column
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Column(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: teal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: teal.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      '$stepNumber',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: teal.withOpacity(0.15),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          // Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: teal,
                    fontFamily: 'Inter Tight',
                  ),
                ),
                const SizedBox(height: 12),
                child,
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

