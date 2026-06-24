import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  const Subtitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Align your National ID card inside the frame',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600],
        fontFamily: 'Inter Tight',
      ),
    );
  }
}
