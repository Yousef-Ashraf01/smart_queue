// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../widgets/time_circle.dart';
import '../widgets/service_card.dart';
import '../widgets/gradient_button(Cansle.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFDDEDFE),
      body: SafeArea(
        child: Stack(
          children: [
            /// Back button (no background, no action)
            Positioned(
              top: 16,
              left: 16,
              child: _iconButton(icon: Icons.arrow_back),
            ),

            /// Bell button (no background, no action)
            Positioned(
              top: 16,
              right: 16,
              child: _iconButton(icon: Icons.notifications_none),
            ),

            /// Title
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "الهيئة القومية للبريد",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            /// Time circle
            Positioned(
              top: 120,
              left: width / 2 - 142,
              child: TimeCircle(time: "09:25 AM", progress: 0.75),
            ),

            /// Service card
            Positioned(bottom: 120, left: 16, right: 16, child: ServiceCard()),

            /// Cancel button
            Positioned(
              bottom: 24,
              left: 48,
              right: 48,
              child: GradientButton(text: "Cancel", onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔘 Icon button with hover / ripple – no background, no action
  Widget _iconButton({required IconData icon}) {
    return InkWell(
      onTap: () {}, // ❌ intentionally no action
      borderRadius: BorderRadius.circular(30),
      splashColor: Colors.black.withValues(alpha: 0.08),
      highlightColor: Colors.black.withValues(alpha: 0.04),
      child: SizedBox(
        width: 44,
        height: 44,
        child: Icon(icon, color: Colors.black, size: 26),
      ),
    );
  }
}
