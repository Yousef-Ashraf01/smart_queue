import 'package:flutter/material.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/info_line.dart';

class IDCard extends StatelessWidget {
  const IDCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.85),
        border: Border.all(color: Colors.white, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'National ID card',
            style: TextStyle(
              fontSize: 7,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D4F5C),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCE1126),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 2),
              Container(
                width: 20,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 34,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    118,
                    226,
                    136,
                  ).withOpacity(0.35),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: Color.fromARGB(255, 11, 58, 30),
                  size: 18,
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InfoLine(widthFraction: 0.85),
                    const SizedBox(height: 5),
                    InfoLine(widthFraction: 0.65),
                    const SizedBox(height: 5),
                    InfoLine(widthFraction: 0.75),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
