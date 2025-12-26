import 'package:flutter/material.dart';
import 'package:smart_queue/features/main/main_screen.dart';

void main() {
  runApp(const SmartQueueApp());
}

class SmartQueueApp extends StatelessWidget {
  const SmartQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: MainScreen(),
    );
  }
}
