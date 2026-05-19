import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class CameraPlaceholder extends StatelessWidget {
  const CameraPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.cameraBg,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.tealLight,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
