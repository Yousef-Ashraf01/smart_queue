import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Align your ID card inside the frame',
      style: TextStyle(fontSize: 13, color: AppColors.tealMuted),
    );
  }
}
