import 'package:flutter/material.dart';
import 'package:smart_queue/features/home/presentation/view/home_screen.dart';
import 'package:smart_queue/features/operations_history/presentation/view/operations_history_screen.dart';
import 'package:smart_queue/features/profile_settings/presentation/view/profile_settings_screen.dart';
import 'package:smart_queue/features/timer/presentation/veiw/timer_screen.dart';

import 'widgets/center_fab.dart';
import 'widgets/custom_bottom_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  void onTabChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body:
          currentIndex == 1
              ? TimerScreen(
                  initialDuration: TimerScreen.pendingDuration,
                  onBookNow: () => onTabChanged(0),
                )
              : [
                HomeScreen(
                  onNavigateToQueue: () => onTabChanged(1),
                  onNavigateToAppointments: () => onTabChanged(2),
                ),
                const OperationsHistoryScreen(),
                ProfileSettingsScreen(),
              ][currentIndex == 0 ? 0 : currentIndex - 1],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const CenterFab(),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: currentIndex,
        onTap: onTabChanged,
      ),
    );
  }
}
