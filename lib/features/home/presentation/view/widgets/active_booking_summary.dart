import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';

class ActiveBookingSummary extends StatefulWidget {
  final VoidCallback onTap;

  const ActiveBookingSummary({super.key, required this.onTap});

  @override
  State<ActiveBookingSummary> createState() => _ActiveBookingSummaryState();
}

class _ActiveBookingSummaryState extends State<ActiveBookingSummary> {
  Timer? _ticker;
  Duration? _remaining;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      final state = context.read<ActiveBookingCubit>().state;
      if (state is ActiveBookingLoaded && state.bookings.isNotEmpty) {
        final booking = state.bookings.first;
        final slotStartRaw = booking[BookingKeys.slotStart] as String?;
        if (slotStartRaw != null) {
          final slotStart = DateTime.tryParse(slotStartRaw);
          if (slotStart != null) {
            final diff = slotStart.difference(DateTime.now());
            setState(() {
              _remaining = diff.isNegative ? Duration.zero : diff;
            });
            return;
          }
        }
      }
      setState(() {
        _remaining = null;
      });
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    if (h > 0) {
      return '${h}h ${m.toString().padLeft(2, '0')}m';
    }
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveBookingCubit, ActiveBookingState>(
      builder: (context, state) {
        final hasBookings =
            state is ActiveBookingLoaded && state.bookings.isNotEmpty;

        return GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors:
                    hasBookings
                        ? [const Color(0xFF1A9E7A), const Color(0xFF0D7355)]
                        : [const Color(0xFFE8F5E9), const Color(0xFFE0F2F1)],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color:
                      hasBookings
                          ? const Color(0xFF1A9E7A).withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: hasBookings ? _buildActive(state) : _buildEmpty(),
          ),
        );
      },
    );
  }

  Widget _buildActive(ActiveBookingLoaded state) {
    final booking = state.bookings.first;
    final serviceName = booking['serviceName'] as String? ?? '';
    final branchName = booking['branchName'] as String? ?? '';
    final count = state.bookings.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.access_time_filled_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Active Booking${count > 1 ? 's ($count)' : ''}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    serviceName,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child:
                  _remaining == null
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                      : Text(
                        _formatDuration(_remaining!),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              color: Colors.white.withValues(alpha: 0.7),
              size: 16,
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                branchName,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              children: [
                Text(
                  'View Details',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white.withValues(alpha: 0.9),
                  size: 12,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1A9E7A).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.event_available_rounded,
            color: Color(0xFF1A9E7A),
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'No upcoming appointments',
                style: TextStyle(
                  color: Color(0xFF2D3436),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Book a service to get started',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
              ),
            ],
          ),
        ),
        Icon(
          Icons.arrow_forward_ios_rounded,
          color: Colors.grey.shade400,
          size: 16,
        ),
      ],
    );
  }
}
