import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const GradientButton({super.key, required this.text, required this.onTap});

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late double _scale;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.04,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1.0 - _controller.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: Transform.scale(
        scale: _scale,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                AppColors.tealLight,
                AppColors.teal,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.teal.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter Tight',
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

