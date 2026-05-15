import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';
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

  void _loadBooking() async {
    final prefs = await SharedPreferences.getInstance();

    final slotStart = prefs.getString('slot_start_time');

    if (slotStart != null) {
      context.read<ActiveBookingCubit>().setBooking({
        "branchName": prefs.getString('branchName'),
        "branchAddress": prefs.getString('branchAddress'),
        "serviceName": prefs.getString('serviceName'),
        "serviceDesc": prefs.getString('serviceDesc'),
        "slotStart": slotStart,
        "createdAt": prefs.getString('createdAt'),
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  final screens = [
    HomeScreen(),
    null,
    const OperationsHistoryScreen(),
    ProfileSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body:
          currentIndex == 1
              ? TimerScreen(initialDuration: TimerScreen.pendingDuration)
              : [
                HomeScreen(),
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
