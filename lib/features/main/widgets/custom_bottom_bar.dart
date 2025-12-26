import 'package:flutter/material.dart';
import 'package:smart_queue/core/constants/app_assets.dart';

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
      color: Colors.white,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavItem(
              icon: AppAssets.iconHome,
              label: "Home",
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            NavItem(
              icon: AppAssets.iconLocation,
              label: "Location",
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            const SizedBox(width: 40),
            NavItem(
              icon: AppAssets.iconCalendar,
              label: "Operations",
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            NavItem(
              icon: AppAssets.iconProfile,
              label: "Profile",
              isActive: currentIndex == 3,
              onTap: () => onTap(3),
            ),
          ],
        ),
      ),
    );
  }
}
