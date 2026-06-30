import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/step_circle.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/step_line.dart';

class StepsIndicator extends StatelessWidget {
  const StepsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StepCircle(number: 1, label: 'scan_id'.tr(), isActive: true),
        const StepLine(isActive: false),
        StepCircle(number: 2, label: 'register'.tr(), isActive: false),
        const StepLine(isActive: false),
        StepCircle(number: 3, label: 'login'.tr(), isActive: false),
      ],
    );
  }
}
