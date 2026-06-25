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
      scale: widget.enabled && _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
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
        child: Container(
          height: 54,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: widget.enabled
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFCA5A5), // Rose light
                      Color(0xFFEF4444), // Rose main red
                    ],
                  )
                : null,
            color: widget.enabled ? null : Colors.grey[300],
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
            border: widget.enabled
                ? Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel_outlined,
                color: widget.enabled ? Colors.white : Colors.grey[500],
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.enabled ? Colors.white : Colors.grey[500],
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  fontFamily: 'Inter Tight',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
