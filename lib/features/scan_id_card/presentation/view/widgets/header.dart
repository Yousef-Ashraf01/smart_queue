import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_queue/features/scan_id_card/presentation/view/widgets/circle_button.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: [
          CircleButton(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16,
              color: textColor,
            ),
          ),
          Expanded(
            child: Text(
              'scan_id_card'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: textColor,
                letterSpacing: -0.3,
                fontFamily: 'Inter Tight',
              ),
            ),
          ),
          const SizedBox(width: 42), // to balance the back button width
        ],
      ),
    );
  }
}
