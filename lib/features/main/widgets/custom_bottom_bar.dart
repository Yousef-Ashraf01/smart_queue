import 'package:flutter/material.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/theme/app_theme.dart';

import 'nav_item.dart';

class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: context.appTheme.navBarBg,
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.12),

      clipBehavior: Clip.none,
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: AppAssets.iconHome,
              label: "nav_home".tr(),
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            NavItem(
              icon: Icons.queue_play_next_rounded,
              label: "nav_my_queue".tr(),
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            const SizedBox(width: 46), // Optimized space for the notched FAB
            NavItem(
              icon: AppAssets.iconCalendar,
              label: "nav_history".tr(),
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            NavItem(
              icon: AppAssets.iconProfile,
              label: "nav_profile".tr(),
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
