import 'package:flutter/material.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/glass_circle.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/id_card.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/person_stilhoutee.dart';
import 'package:smart_queue/features/welcome/presentation/view/widgets/phone_mockup.dart';

class HeroIllustration extends StatelessWidget {
  const HeroIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            right: 20,
            child: GlassCircle(size: 70, opacity: 0.25),
          ),
          Positioned(
            top: 30,
            left: 10,
            child: GlassCircle(size: 45, opacity: 0.2),
          ),
          Positioned(
            right: 10,
            top: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PersonSilhouette(size: 32, opacity: 0.35),
                const SizedBox(width: 4),
                PersonSilhouette(size: 40, opacity: 0.55),
                const SizedBox(width: 4),
                PersonSilhouette(size: 48, opacity: 0.75),
              ],
            ),
          ),
          Positioned(
            right: 80,
            top: 50,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.monitor_heart_outlined,
                color: Color.fromARGB(255, 11, 58, 30),
                size: 22,
              ),
            ),
          ),
          Positioned(
            right: 30,
            top: 90,
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bar_chart_rounded,
                color: Color.fromARGB(255, 11, 58, 30),
                size: 20,
              ),
            ),
          ),
          Positioned(
            left: 20,
            top: 60,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color.fromARGB(
                  255,
                  118,
                  226,
                  136,
                ).withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Color.fromARGB(255, 11, 58, 30),
                size: 28,
              ),
            ),
          ),
          Positioned(
            left: 50,
            top: 100,
            child: Icon(
              Icons.favorite_border_rounded,
              color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.5),
              size: 22,
            ),
          ),
          const Center(child: PhoneMockup()),
          Positioned(
            bottom: 0,
            right: 20,
            child: Transform.rotate(angle: -0.12, child: const IDCard()),
          ),
        ],
      ),
    );
  }
}
