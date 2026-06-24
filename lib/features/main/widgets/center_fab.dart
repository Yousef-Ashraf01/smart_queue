import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/routing/app_routes.dart';

class CenterFab extends StatefulWidget {
  const CenterFab({super.key});

  @override
  State<CenterFab> createState() => _CenterFabState();
}

class _CenterFabState extends State<CenterFab> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryGlow = Color(0xff10B981);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: () {
        context.push(AppRoutes.ai);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.90 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedBuilder(
          animation: _pulseController,
          builder: (context, child) {
            final pulseVal = _pulseController.value;
            return Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF34D399), // Emerald 400
                    Color(0xFF059669), // Emerald 600
                  ],
                ),
                boxShadow: [
                  // Outer soft glowing aura pulsing smoothly
                  BoxShadow(
                    color: primaryGlow.withOpacity(0.2 + (pulseVal * 0.15)),
                    blurRadius: 12 + (pulseVal * 10),
                    spreadRadius: 1 + (pulseVal * 2),
                    offset: const Offset(0, 4),
                  ),
                  // Strong bottom shadow
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.35),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  AppAssets.iconAi,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                  width: 26,
                  height: 26,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
