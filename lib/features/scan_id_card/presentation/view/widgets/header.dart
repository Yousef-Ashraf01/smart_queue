import 'package:flutter/material.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/circle_button.dart';

import '../../../../../core/styling/app_colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          CircleButton(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppColors.teal,
            ),
          ),
          const Expanded(
            child: Text(
              'Scan ID Card',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A5C62),
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(width: 42),
        ],
      ),
    );
  }
}
