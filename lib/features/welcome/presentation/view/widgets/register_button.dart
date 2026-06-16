import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterButton extends StatelessWidget {
  final VoidCallback onTap;

  const RegisterButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: const Color.fromARGB(255, 11, 58, 30),
        ),
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.badge_outlined, color: Colors.white, size: 20),
          label: Text(
            'register'.tr(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}
