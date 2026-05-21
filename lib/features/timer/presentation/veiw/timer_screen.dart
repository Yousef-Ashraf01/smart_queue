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
    final state = context.read<ActiveBookingCubit>().state;

    if (state is ActiveBookingLoaded) {
      final booking = state.booking;

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
    _timer?.cancel();
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
    final state = context.watch<ActiveBookingCubit>().state;
    return BlocListener<ActiveBookingCubit, ActiveBookingState>(
      listener: (context, state) {
        if (state is ActiveBookingCancelled) {
          _timer?.cancel();
        }
      },
      child: Scaffold(
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
                state is ActiveBookingLoaded
                    ? _buildTimerContent(state.booking)
                    : _buildEmptyState(context),
          ),
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
                    onTap: () => _showCancelDialog(context, booking),
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

  void _showCancelDialog(BuildContext context, Map booking) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => Dialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.calendar_today_outlined,
                      color: Color(0xFFE24B4A),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Cancel booking?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Are you sure you want to cancel your appointment? This action cannot be undone.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.work_outline,
                              size: 15,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "Service",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              booking['serviceName'] ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 15,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              "Time slot",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              booking['slotStartTime'] ?? "",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Keep it",
                            style: TextStyle(color: Colors.black87),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await context
                                .read<ActiveBookingCubit>()
                                .cancelBooking(
                                  booking['id'],
                                  booking['counterId'],
                                  booking['slotStartTime'] ?? "",
                                );
                            _timer?.cancel();
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE24B4A),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Yes, cancel",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
