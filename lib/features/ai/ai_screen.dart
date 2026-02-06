import 'package:flutter/material.dart';
import 'package:smart_queue/core/constants/app_assets.dart';
import 'package:smart_queue/core/widgets/custom_app_bar.dart';
import 'package:smart_queue/core/widgets/status_bar_scaffold.dart';


class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StatusBarScaffold(
      child: Column(
        children: [
          CustomAppBar(
            title: '',
            showNotificationDot: true,
            onNotificationPress: () {},
          ),

          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Image.asset(
                    AppAssets.aiRobot,
                    height: 220,
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    "Hello, Mohamed Ayad",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "How can I help you?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.attach_file, color: Colors.black, size: 26),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 64,
              padding: const EdgeInsets.only(left: 20, right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Ask AI",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    height: 48,
                    width: 54,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00FF22), Color(0xFF000000)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(27),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.auto_awesome_outlined, color: Colors.white, size: 20),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}