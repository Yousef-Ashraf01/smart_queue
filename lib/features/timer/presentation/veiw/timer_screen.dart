import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
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
  // Per-booking countdown state: keyed by appointment id
  final Map<int, Duration> _remainingMap = {};
  final Map<int, Duration> _totalDurationMap = {};
  Timer? _ticker;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initTimers();
  }

  void _initTimers() {
    final state = context.read<ActiveBookingCubit>().state;
    if (state is ActiveBookingLoaded) {
      for (final booking in state.bookings) {
        _setupBookingTimer(booking);
      }
    }

    // Remove any booking that is already expired before displaying anything
    final expiredIds =
        _remainingMap.entries
            .where((e) => e.value.inSeconds <= 0)
            .map((e) => e.key)
            .toList();
    for (final id in expiredIds) {
      _remainingMap.remove(id);
      _totalDurationMap.remove(id);
      context.read<ActiveBookingCubit>().removeBooking(id);
    }

    _startTicker();
  }

  void _setupBookingTimer(Map<String, dynamic> booking) {
    final id = booking['id'] as int?;
    if (id == null) return;

    try {
      final slotStartRaw = booking[BookingKeys.slotStart] as String?;
      final createdAtRaw = booking['createdAt'] as String?;
      if (slotStartRaw == null || createdAtRaw == null) return;

      final slotStart = DateTime.parse(slotStartRaw);
      final createdAt = DateTime.parse(createdAtRaw);
      final totalDuration = slotStart.difference(createdAt);
      final remaining = slotStart.difference(DateTime.now());
      final resolvedRemaining =
          remaining.isNegative ? Duration.zero : remaining;

      _remainingMap[id] = resolvedRemaining;
      _totalDurationMap[id] = totalDuration;
    } catch (_) {
      _remainingMap[id] = Duration.zero;
      _totalDurationMap[id] = Duration.zero;
    }
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        final expiredIds = <int>[];
        for (final id in _remainingMap.keys.toList()) {
          final current = _remainingMap[id]!;
          if (current.inSeconds <= 0) {
            expiredIds.add(id);
          } else {
            _remainingMap[id] = current - const Duration(seconds: 1);
          }
        }
        for (final id in expiredIds) {
          _remainingMap.remove(id);
          _totalDurationMap.remove(id);
          context.read<ActiveBookingCubit>().removeBooking(id);
        }
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  String _formattedTime(int id) {
    final remaining = _remainingMap[id] ?? Duration.zero;
    final h = remaining.inHours.toString().padLeft(2, '0');
    final m = (remaining.inMinutes % 60).toString().padLeft(2, '0');
    final s = (remaining.inSeconds % 60).toString().padLeft(2, '0');
    return h != '00' ? "$h:$m:$s" : "$m:$s";
  }

  double _remainingProgress(int id) {
    final total = _totalDurationMap[id]?.inSeconds ?? 0;
    if (total <= 0) return 0;
    final remaining = _remainingMap[id]?.inSeconds ?? 0;
    return (remaining / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActiveBookingCubit, ActiveBookingState>(
      listener: (context, state) {
        if (state is ActiveBookingLoaded) {
          // Sync newly added bookings into the timer map
          for (final booking in state.bookings) {
            final id = booking['id'] as int?;
            if (id != null && !_remainingMap.containsKey(id)) {
              _setupBookingTimer(booking);
            }
          }
          // Remove bookings that no longer exist in state
          final activeIds =
              state.bookings
                  .map((b) => b['id'] as int?)
                  .whereType<int>()
                  .toSet();
          _remainingMap.removeWhere((id, _) => !activeIds.contains(id));
          _totalDurationMap.removeWhere((id, _) => !activeIds.contains(id));
        }

        if (state is ActiveBookingCancelled) {
          _ticker?.cancel();
          _startTicker();
        }

        if (state is ActiveBookingError) {
          AppFlushbar.show(
            context,
            message: state.message,
            type: MessageType.error,
          );
        }
      },
      child: BlocBuilder<ActiveBookingCubit, ActiveBookingState>(
        builder: (context, state) {
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
                    state is ActiveBookingLoaded && state.bookings.isNotEmpty
                        ? _buildMultiBookingView(state.bookings)
                        : _buildEmptyState(context),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMultiBookingView(List<Map<String, dynamic>> bookings) {
    return Column(
      children: [
        const SizedBox(height: 25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: NotificationWidget(),
          ),
        ),
        const SizedBox(height: 10),

        // Page indicator dots (only shown when multiple bookings)
        if (bookings.length > 1) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bookings.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? const Color(0xff1A9E7A)
                          : const Color(0xff1A9E7A).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
        ],

        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: bookings.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (context, index) {
              return _buildBookingCard(bookings[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    final id = booking['id'] as int? ?? 0;
    final orgName = booking['orgName'] as String? ?? 'Egyptian Post';
    final canCancel = booking['canCancel'] as bool? ?? true;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
        child: Column(
          children: [
            Text(
              orgName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 30),

            Center(
              child: TimeCircle(
                time: _formattedTime(id),
                progress: _remainingProgress(id),
              ),
            ),

            const SizedBox(height: 30),

            ServiceCard(
              serviceName: booking['serviceName'] as String? ?? "",
              branchName: booking['branchName'] as String? ?? "",
              branchAddress: booking['branchAddress'] as String? ?? "",
            ),

            const SizedBox(height: 30),

            GradientButton(
              text: "Cancel",
              enabled: canCancel,
              onTap: () => _showCancelDialog(context, booking),
            ),

            if (!canCancel) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Color(0xFFE24B4A),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Cancellation limit reached for this service (Allowed once).",
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCancelDialog(BuildContext context, Map<String, dynamic> booking) {
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
                    decoration: const BoxDecoration(
                      color: Color(0xFFFEE2E2),
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
                              booking['serviceName'] as String? ?? "",
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
                              booking[BookingKeys.slotStartTime] as String? ??
                                  "",
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
                                .cancelBooking(booking['id'] as int);
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
        children: const [
          Icon(Icons.event_busy, size: 80, color: Colors.grey),
          SizedBox(height: 20),
          Text(
            "No Active Booking",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            "You don't have any booking yet",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
