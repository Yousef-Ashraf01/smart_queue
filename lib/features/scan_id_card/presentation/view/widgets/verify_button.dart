import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class VerifyButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const VerifyButton({super.key, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.45,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: enabled ? onTap : null,
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 118, 226, 136),
                  Color.fromARGB(255, 11, 58, 30),
                ],
              ),
              boxShadow:
                  enabled
                      ? [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            11,
                            58,
                            30,
                          ).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                      : [],
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.verified_user_rounded,
                  color: AppColors.white,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'Verify ID',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
