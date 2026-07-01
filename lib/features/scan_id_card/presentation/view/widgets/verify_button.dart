import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class VerifyButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const VerifyButton({super.key, required this.enabled, required this.onTap});

  @override
  State<VerifyButton> createState() => _VerifyButtonState();
}

class _VerifyButtonState extends State<VerifyButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF10B981);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: AnimatedOpacity(
        opacity: widget.enabled ? 1.0 : 0.5,
        duration: const Duration(milliseconds: 250),
        child: GestureDetector(
          onTapDown: (_) {
            if (widget.enabled) setState(() => _isPressed = true);
          },
          onTapUp: (_) {
            if (widget.enabled) setState(() => _isPressed = false);
          },
          onTapCancel: () {
            if (widget.enabled) setState(() => _isPressed = false);
          },
          onTap: widget.enabled ? widget.onTap : null,
          child: AnimatedScale(
            scale: _isPressed ? 0.96 : 1.0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutCubic,
            child: Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient:
                    widget.enabled
                        ? const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF34D399), // Emerald 400
                            Color(0xFF059669), // Emerald 600
                          ],
                        )
                        : null,
                color: widget.enabled ? null : Colors.grey[300],
                boxShadow:
                    widget.enabled
                        ? [
                          BoxShadow(
                            color: activeColor.withOpacity(0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ]
                        : [],
                border:
                    widget.enabled
                        ? Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        )
                        : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.verified_user_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'verify_id_card'.tr(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      fontFamily: 'Inter Tight',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
