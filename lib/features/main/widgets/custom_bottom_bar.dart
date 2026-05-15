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
            NavigationItem(
              icon: Icons.queue,
              label: "My Queue",
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            const SizedBox(width: 40),
            NavItem(
              icon: AppAssets.iconCalendar,
              label: "Appointments",
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

class NavigationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavigationItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.black : Colors.grey),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: isActive ? 14 : 12,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
