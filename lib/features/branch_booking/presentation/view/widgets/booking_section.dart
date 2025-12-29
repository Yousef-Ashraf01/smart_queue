import 'package:flutter/material.dart';

class BookingSection extends StatelessWidget {
  final String title;
  final Widget child;

  const BookingSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 10),
      ],
    );
  }
}
