import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_styles.dart';

class TimeCircle extends StatelessWidget {
  final String time;
  final double progress;

  const TimeCircle({super.key, required this.time, required this.progress});

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF10B981);

    return SizedBox(
      width: 264,
      height: 264,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Ring Track
          SizedBox(
            width: 248,
            height: 248,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation(activeColor.withOpacity(0.08)),
            ),
          ),

          // Active Glowing Progress Ring with ShaderMask Gradient
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF34D399), // Emerald 400
                  activeColor,
                  activeColor.withOpacity(0.8),
                ],
              ).createShader(rect);
            },
            child: SizedBox(
              width: 248,
              height: 248,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8,
                strokeCap: StrokeCap.round,
                backgroundColor: Colors.transparent,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),

          // Glow effect underneath the active progress ring
          IgnorePointer(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: activeColor.withOpacity(0.06 * progress),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          // Inner Premium Circular Card Container
          Container(
            width: 216,
            height: 216,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: activeColor.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: activeColor.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.hourglass_bottom_rounded,
                        size: 11,
                        color: activeColor.withOpacity(0.8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "REMAINING TIME",
                        style: TextStyle(
                          fontFamily: AppStyle.fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: activeColor.withOpacity(0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  time,
                  style: const TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1D4E),
                    letterSpacing: -1.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
