import 'dart:ui';

import 'package:flutter/material.dart';

class CustomMeshGradient extends StatelessWidget {
  final List<Color> colors;
  final double blurSigma;
  final Widget? child;

  const CustomMeshGradient({
    super.key,
    required this.colors,
    this.blurSigma = 70,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(color: colors[1]),
        Positioned(top: -100, left: -50, child: _circle(colors[0], 400)),
        Positioned(top: 200, right: -100, child: _circle(colors[1], 500)),
        Positioned(bottom: -100, left: -50, child: _circle(colors[3], 450)),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(color: Colors.transparent),
        ),
        if (child != null) child!,
      ],
    );
  }

  Widget _circle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
