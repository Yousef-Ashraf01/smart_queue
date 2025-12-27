import 'package:flutter/material.dart';
import 'package:smart_queue/features/home/presentation/view/home_screen.dart';

import 'widgets/center_fab.dart';
import 'widgets/custom_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final screens = [
    HomeScreen(),
    Container(color: Colors.red),
    Container(color: Colors.brown),
    Container(color: Colors.blue),
    Container(color: Colors.yellow),
  ];

  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: screens[currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CenterFab(),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}
