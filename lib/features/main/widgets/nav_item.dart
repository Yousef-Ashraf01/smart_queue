import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NavItem extends StatelessWidget {
  final dynamic icon; // Supports String (SVG) or IconData (Material Icons)
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
    const activeColor = Color(0xFF10B981); // Modern emerald/teal
    final inactiveColor = Colors.grey[400]!;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 68,
        height: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Container with soft hover background and scaling
            AnimatedScale(
              scale: isActive ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isActive ? activeColor.withOpacity(0.08) : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: icon is String
                    ? SvgPicture.asset(
                        icon as String,
                        height: 20,
                        width: 20,
                        colorFilter: ColorFilter.mode(
                          isActive ? activeColor : inactiveColor,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(
                        icon as IconData,
                        size: 20,
                        color: isActive ? activeColor : inactiveColor,
                      ),
              ),
            ),
            const SizedBox(height: 3),
            // Text Label
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? activeColor : inactiveColor,
                fontFamily: 'Inter Tight',
                letterSpacing: -0.1,
              ),
              child: Text(label),
            ),
            const SizedBox(height: 3),
            // Glow active indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 4,
              width: isActive ? 4 : 0,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
