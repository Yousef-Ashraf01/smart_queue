import 'package:flutter/material.dart';

import '../../../../../core/styling/app_colors.dart';

class ScanLine extends StatelessWidget {
  final Animation<double> scanAnim;

  const ScanLine({super.key, required this.scanAnim});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: scanAnim,
      builder: (_, __) {
        final t = Curves.easeInOut.transform(scanAnim.value);
        return Positioned(
          top: null,
          left: 0,
          right: 0,
          bottom: null,
          child: Align(
            alignment: Alignment(0, -0.4 + 0.8 * t),
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Colors.transparent,
                    AppColors.tealLight,
                    AppColors.tealLight,
                    Colors.transparent,
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tealLight.withOpacity(0.6),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
