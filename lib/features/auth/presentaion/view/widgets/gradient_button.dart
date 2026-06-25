import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool isLoading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [
              AppColors.tealLight,
              AppColors.teal,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.teal.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: isLoading ? null : onTap,
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                )
              : Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
