import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/core/widgets/app_flushbar.dart';
import 'package:smart_queue/core/widgets/notification_widget.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/gradient_button.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/service_card.dart';
import 'package:smart_queue/features/timer/presentation/veiw/widgets/time_circle.dart';

class TimerScreen extends StatefulWidget {
  final Duration initialDuration;
  final VoidCallback? onBookNow;

  static Duration pendingDuration = Duration.zero;

  const TimerScreen({
    super.key,
    this.initialDuration = Duration.zero,
    this.onBookNow,
  });

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
  List<Map<String, dynamic>> _lastBookings = [];

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
            message: state.message.localizedApi,
            type: MessageType.error,
          );
        }
      },
      child: BlocBuilder<ActiveBookingCubit, ActiveBookingState>(
        builder: (context, state) {
          if (state is ActiveBookingLoaded && state.bookings.isNotEmpty) {
            _lastBookings = state.bookings;
          }

          final currentBookings =
              state is ActiveBookingLoaded && state.bookings.isNotEmpty
                  ? state.bookings
                  : state is ActiveBookingCancelling
                  ? _lastBookings
                  : (state is ActiveBookingLoaded
                      ? <Map<String, dynamic>>[]
                      : _lastBookings);

          final int bookingsCount = currentBookings.length;

          return Scaffold(
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.bgTop, AppColors.bgBottom],
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // Structured and modern Header
                    _buildHeader(bookingsCount),

                    Expanded(
                      child:
                          state is ActiveBookingLoading
                              ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.teal,
                                ),
                              )
                              : bookingsCount > 0
                              ? _buildMultiBookingView(currentBookings)
                              : _buildEmptyState(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "my_queue".tr(),
                  style: const TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryDark,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count > 0
                      ? "active_tickets_progress".tr(args: [count.toString()])
                      : "check_active_queue_status".tr(),
                  style: const TextStyle(
                    fontFamily: AppStyle.fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: AppColors.greyText,
                  ),
                ),
              ],
            ),
          ),
          const NotificationWidget(),
        ],
      ),
    );
  }

  Widget _buildMultiBookingView(List<Map<String, dynamic>> bookings) {
    return Column(
      children: [
        // Page indicator dots (only shown when multiple bookings)
        if (bookings.length > 1) ...[
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(bookings.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color:
                      isActive
                          ? const Color(0xFF10B981)
                          : const Color(0xFF10B981).withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
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
    final orgName =
        (booking['orgName'] as String? ?? 'Egyptian Post').localizedApi;
    final canCancel = booking['canCancel'] as bool? ?? true;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.teal.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: AppColors.tealLight.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Text(
                orgName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: AppStyle.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.teal,
                  letterSpacing: 0.3,
                ),
              ),
            ),

            const SizedBox(height: 24),

            Center(
              child: TimeCircle(
                time: _formattedTime(id),
                progress: _remainingProgress(id),
              ),
            ),

            const SizedBox(height: 24),

            ServiceCard(
              serviceName: booking['serviceName'] as String? ?? "",
              branchName: booking['branchName'] as String? ?? "",
              branchAddress: booking['branchAddress'] as String? ?? "",
            ),

            const SizedBox(height: 24),

            GradientButton(
              text: "cancel_appointment".tr(),
              enabled: canCancel,
              onTap: () => _showCancelDialog(context, booking),
            ),

            if (!canCancel) ...[
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2F2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFFEE2E2), width: 1),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xFFE24B4A),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "cancellation_limit_reached".tr(),
                        style: TextStyle(
                          fontFamily: AppStyle.fontFamily,
                          color: Colors.red[900],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
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
                border: Border.all(
                  color: AppColors.tealLight.withValues(alpha: 0.15),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFEE2E2),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.warning_amber_rounded,
                      color: Color(0xFFE24B4A),
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "cancel_booking_question".tr(),
                    style: const TextStyle(
                      fontFamily: AppStyle.fontFamily,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "cancel_booking_confirm".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: AppStyle.fontFamily,
                      fontSize: 14,
                      color: AppColors.greyText,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.bgBottom.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.tealLight.withValues(alpha: 0.15),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.room_service_outlined,
                              size: 16,
                              color: AppColors.tealMuted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "service_label".tr(),
                              style: const TextStyle(
                                fontFamily: AppStyle.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tealMuted,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: Text(
                                (booking['serviceName'] as String? ?? "")
                                    .localizedApi,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                  fontFamily: AppStyle.fontFamily,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.blackColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(
                              Icons.schedule_outlined,
                              size: 16,
                              color: AppColors.tealMuted,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "time_slot".tr(),
                              style: const TextStyle(
                                fontFamily: AppStyle.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tealMuted,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              booking[BookingKeys.slotStartTime] as String? ??
                                  "",
                              style: const TextStyle(
                                fontFamily: AppStyle.fontFamily,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(
                              color: AppColors.tealLight.withValues(alpha: 0.6),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "keep_it".tr(),
                            style: const TextStyle(
                              fontFamily: AppStyle.fontFamily,
                              color: AppColors.teal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
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
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: Text(
                            "yes_cancel".tr(),
                            style: const TextStyle(
                              fontFamily: AppStyle.fontFamily,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF34D399), Color(0xFF10B981)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF10B981,
                          ).withValues(alpha: 0.25),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.hourglass_empty_rounded,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "no_active_bookings_title".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppStyle.fontFamily,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primaryDark,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "no_active_bookings_desc".tr(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppStyle.fontFamily,
                  fontSize: 14,
                  color: AppColors.greyText,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 28),
              _BookButton(
                onTap: () {
                  if (widget.onBookNow != null) {
                    widget.onBookNow!();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BookButton({required this.onTap});

  @override
  State<_BookButton> createState() => _BookButtonState();
}

class _BookButtonState extends State<_BookButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOutCubic,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: Container(
          height: 50,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF34D399), // Emerald 400
                Color(0xFF10B981), // Emerald 500
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF10B981).withValues(alpha: 0.2),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "book_new_appointment".tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                  fontFamily: 'Inter Tight',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
