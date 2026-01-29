import 'package:flutter/material.dart';

class TimeCircle extends StatelessWidget {
  final String time;
  final double progress;

  const TimeCircle({super.key, required this.time, required this.progress});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 284,
      height: 284,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// 🟢 Green solid border (real border)
          Container(
            width: 284,
            height: 284,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromARGB(255, 255, 255, 255),
                width: 4, // سمك البوردر
              ),
            ),
          ),

          /// (اختياري) Progress فوق البوردر
          SizedBox(
            width: 284,
            height: 298,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 8,
              backgroundColor: Colors.transparent,
              valueColor: AlwaysStoppedAnimation(Color(0xFF2ECC71)),
            ),
          ),

          /// ⚪ Inner white circle
          Container(
            width: 250,
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x267D7789),
                  blurRadius: 8,
                  offset: Offset(2, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Remaining time for you",
                  style: TextStyle(fontSize: 13, color: Color(0xFFABA9AF)),
                ),
                SizedBox(height: 8),
                Text(
                  time,
                  style: TextStyle(fontSize: 33, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
