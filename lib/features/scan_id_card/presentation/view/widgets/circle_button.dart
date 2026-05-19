import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class CircleButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const CircleButton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.white,
          border: Border.all(color: AppColors.tealSubtle),
        ),
        child: Center(child: child),
      ),
    );
  }
}
