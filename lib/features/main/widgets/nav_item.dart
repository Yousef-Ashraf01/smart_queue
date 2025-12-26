import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavItem({
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
          SvgPicture.asset(icon, color: isActive ? Colors.black : Colors.grey),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
