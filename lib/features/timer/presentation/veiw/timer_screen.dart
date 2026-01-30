// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/gradient_button.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/service_card.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/time_circle.dart';

class TimerScreen extends StatelessWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFDDEDFE),
      body: SafeArea(
        child: Stack(
          children: [
            /// Bell button (no background, no action)
            Positioned(top: 16, right: 16, child: NotificationWidget()),

            /// Title
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "National Postal Authority",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                ),
              ),
            ),

            /// Time circle
            Positioned(
              top: 150,
              left: width / 2 - 142,
              child: TimeCircle(time: "09:25 AM", progress: 0.75),
            ),

            /// Service card
            Positioned(bottom: 130, left: 16, right: 16, child: ServiceCard()),

            /// Cancel button
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: GradientButton(text: "Cancel", onTap: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton({required IconData icon}) {
    return InkWell(
      onTap: () {},
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
