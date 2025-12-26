import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: AppBar(title: Text("Home")),
        body: Center(
          child: Text("Home Screen", style: TextStyle(fontSize: 22)),
        ),
      ),
    );
  }
}
