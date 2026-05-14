import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/gradient_button.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/service_card.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/time_circle.dart';

class TimerScreen extends StatefulWidget {
  final Duration initialDuration;

  static Duration pendingDuration = Duration.zero;

  const TimerScreen({super.key, this.initialDuration = Duration.zero});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Duration _remaining = Duration.zero;
  Duration _totalDuration = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadAndStart();
  }

  Future<void> _loadAndStart() async {
    final booking = context.read<ActiveBookingCubit>().state;

    if (booking != null && booking['slotStart'] != null) {
      final slotStart = DateTime.parse(booking['slotStart']);
      final createdAt = DateTime.parse(booking['createdAt']);

      final totalDuration = slotStart.difference(createdAt);
      final remaining = slotStart.difference(DateTime.now());

      final resolvedRemaining =
          remaining.isNegative ? Duration.zero : remaining;

      setState(() {
        _remaining = resolvedRemaining;
        _totalDuration = totalDuration;
      });
    } else {
      setState(() {
        _remaining = Duration.zero;
        _totalDuration = Duration.zero;
      });
    }

    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remaining.inSeconds <= 0) {
        _timer?.cancel();

        context.read<ActiveBookingCubit>().clearBooking();
      } else {
        setState(() => _remaining -= const Duration(seconds: 1));
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final h = _remaining.inHours.toString().padLeft(2, '0');
    final m = (_remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (_remaining.inSeconds % 60).toString().padLeft(2, '0');
    return h != '00' ? "$h:$m:$s" : "$m:$s";
  }

  double get _progress {
    final total = _totalDuration.inSeconds;
    if (total == 0) return 0;
    return _remaining.inSeconds / total;
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<ActiveBookingCubit>().state;
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xffEEFEFF), Color(0xffD6F9F7)],
          ),
        ),
        child: SafeArea(
          child:
              booking == null
                  ? _buildEmptyState(context)
                  : _buildTimerContent(booking),
        ),
      ),
    );
  }

  Widget _buildTimerContent(Map booking) {
    return Column(
      children: [
        SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: NotificationWidget(),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
              child: Column(
                children: [
                  const Text(
                    "Egyptian Post",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: TimeCircle(
                      time: _formattedTime,
                      progress: _progress,
                    ),
                  ),

                  const SizedBox(height: 40),

                  ServiceCard(
                    serviceName: booking['serviceName'] ?? "",
                    branchName: booking['branchName'] ?? "",
                    branchAddress: booking['branchAddress'] ?? "",
                  ),

                  const SizedBox(height: 40),

                  GradientButton(
                    text: "Cancel",
                    onTap: () async {
                      context.read<ActiveBookingCubit>().clearBooking();

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.event_busy, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "No Active Booking",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "You don’t have any booking yet",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
