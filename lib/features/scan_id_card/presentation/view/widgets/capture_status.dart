import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class CaptureStatus extends StatelessWidget {
  final File? capturedImage;

  const CaptureStatus({super.key, required this.capturedImage});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 14,
      left: 0,
      right: 0,
      child: Text(
        capturedImage != null
            ? '✓  Image captured'
            : 'Hold steady for best results',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          color:
              capturedImage != null
                  ? AppColors.tealLight
                  : Colors.white.withOpacity(0.4),
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
