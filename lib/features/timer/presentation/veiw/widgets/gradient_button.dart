import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final bool enabled;

  const GradientButton({
    super.key,
    required this.text,
    required this.onTap,
    this.enabled = true,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: widget.enabled && _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Material(
        borderRadius: BorderRadius.circular(28),
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.enabled ? widget.onTap : null,
          onHighlightChanged: (value) {
            if (widget.enabled) {
              setState(() => _isPressed = value);
            }
          },
          borderRadius: BorderRadius.circular(28),
          splashColor:
              widget.enabled
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.transparent,
          highlightColor:
              widget.enabled
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.transparent,
          child: Ink(
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors:
                    !widget.enabled
                        ? [Colors.grey[400]!, Colors.grey[500]!]
                        : _isPressed
                        ? [const Color(0xFF702E2E), const Color(0xFFFF3C3C)]
                        : [const Color(0xFFFF3C3C), const Color(0xFF702E2E)],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: widget.enabled ? Colors.white : Colors.white70,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.text,
                    style: TextStyle(
                      color:
                          widget.enabled
                              ? Colors.white
                              : Colors.white.withOpacity(0.8),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
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
