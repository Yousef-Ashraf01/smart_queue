import 'package:flutter/material.dart';
import 'package:smart_queue/core/styling/app_colors.dart';

class IdFrame extends StatelessWidget {
  const IdFrame({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth * 0.82;
        final h = w / 1.586;
        return SizedBox(
          width: w,
          height: h,
          child: CustomPaint(painter: IdFramePainter()),
        );
      },
    );
  }
}

class IdFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final borderPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.35)
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    final cornerPaint =
        Paint()
          ..color = AppColors.tealLight
          ..strokeWidth = 3.0
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    const r = 10.0;
    const cl = 26.0;

    final rrect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(r),
    );
    canvas.drawRRect(rrect, borderPaint);

    final path = Path();

    path.moveTo(0, cl);
    path.lineTo(0, r);
    path.arcToPoint(
      Offset(r, 0),
      radius: const Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(cl, 0);

    path.moveTo(size.width - cl, 0);
    path.lineTo(size.width - r, 0);
    path.arcToPoint(
      Offset(size.width, r),
      radius: const Radius.circular(r),
      clockwise: true,
    );
    path.lineTo(size.width, cl);

    path.moveTo(0, size.height - cl);
    path.lineTo(0, size.height - r);
    path.arcToPoint(
      Offset(r, size.height),
      radius: const Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(cl, size.height);

    path.moveTo(size.width - cl, size.height);
    path.lineTo(size.width - r, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - r),
      radius: const Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(size.width, size.height - cl);

    canvas.drawPath(path, cornerPaint);

    final iconPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.12)
          ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 56, height: 40),
        const Radius.circular(4),
      ),
      iconPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
