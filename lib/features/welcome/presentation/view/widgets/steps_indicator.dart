import 'package:flutter/material.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/step_circle.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/step_line.dart';

class StepsIndicator extends StatelessWidget {
  const StepsIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StepCircle(number: 1, label: 'Scan ID', isActive: true),
        StepLine(isActive: false),
        StepCircle(number: 2, label: 'Register', isActive: false),
        StepLine(isActive: false),
        StepCircle(number: 3, label: 'Login', isActive: false),
      ],
    );
  }
}
