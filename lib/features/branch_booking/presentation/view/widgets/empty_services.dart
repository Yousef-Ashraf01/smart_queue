import 'package:flutter/material.dart';

class EmptyServices extends StatelessWidget {
  const EmptyServices({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: const Column(
        children: [
          Icon(Icons.inbox_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 10),
          Text("No Services yet", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
