import 'package:flutter/material.dart';

class PhoneMockup extends StatelessWidget {
  const PhoneMockup({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.75),
            Colors.white.withOpacity(0.45),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 70,
            child: Container(
              width: 100,
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    const Color.fromARGB(255, 118, 226, 136).withOpacity(0.9),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color.fromARGB(
                  255,
                  118,
                  226,
                  136,
                ).withOpacity(0.45),
              ),
              const SizedBox(height: 8),
              Container(
                width: 54,
                height: 66,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    118,
                    226,
                    136,
                  ).withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            child: Container(
              width: 36,
              height: 6,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
