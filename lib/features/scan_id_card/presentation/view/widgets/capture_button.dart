import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class CaptureButton extends StatelessWidget {
  final Animation<double> captureAnim;
  final VoidCallback onTap;

  const CaptureButton({
    super.key,
    required this.captureAnim,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: captureAnim,
      builder: (_, child) {
        final scale = 1.0 - captureAnim.value * 0.08;
        return Transform.scale(scale: scale, child: child);
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.white,
            border: Border.all(color: AppColors.tealSubtle, width: 3),
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withOpacity(0.15),
                blurRadius: 14,
                spreadRadius: 4,
              ),
            ],
          ),
          child: const Icon(
            Icons.camera_alt_rounded,
            size: 30,
            color: AppColors.teal,
          ),
        ),
      ),
    );
  }
}
