import 'package:flutter/material.dart';

class ReadingOverlay extends StatelessWidget {
  const ReadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 11, 58, 30).withOpacity(0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(
                          255,
                          118,
                          226,
                          136,
                        ).withOpacity(0.15),
                      ),
                    ),
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color.fromARGB(
                          255,
                          118,
                          226,
                          136,
                        ).withOpacity(0.25),
                      ),
                    ),
                    const Icon(
                      Icons.badge_rounded,
                      size: 32,
                      color: Color.fromARGB(255, 11, 58, 30),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reading ID Card',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color.fromARGB(255, 11, 58, 30),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please wait while we extract\nyour information from the card',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  minHeight: 5,
                  backgroundColor: const Color.fromARGB(
                    255,
                    118,
                    226,
                    136,
                  ).withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color.fromARGB(255, 11, 58, 30),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Do not close the app',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
