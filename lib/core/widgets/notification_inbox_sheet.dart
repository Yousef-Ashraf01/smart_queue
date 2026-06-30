import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';

class BookingStatusSheet extends StatelessWidget {
  const BookingStatusSheet({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (_) => BlocProvider.value(
            value: context.read<ActiveBookingCubit>(),
            child: const BookingStatusSheet(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActiveBookingCubit, ActiveBookingState>(
      builder: (context, state) {
        final bookings =
            state is ActiveBookingLoaded
                ? state.bookings
                : <Map<String, dynamic>>[];

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A9E7A).withAlpha(26),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.confirmation_number_outlined,
                        color: Color(0xFF1A9E7A),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'active_bookings'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A9E7A).withAlpha(26),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'active_count'.tr(args: [bookings.length.toString()]),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A9E7A),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),
              const Divider(height: 1, color: Color(0xFFF0F0F0)),

              if (bookings.isEmpty)
                _buildEmpty(context)
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: bookings.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder:
                      (_, i) => _BookingCard(
                        booking: bookings[i],
                        onGoToQueue: () {
                          Navigator.pop(context);
                          context.push(AppRoutes.timer);
                        },
                      ),
                ),

              if (bookings.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        context.push(AppRoutes.timer);
                      },
                      icon: const Icon(Icons.timer_outlined, size: 18),
                      label: Text('view_my_queue'.tr()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A9E7A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        'no_active_bookings'.tr(),
        style: const TextStyle(fontSize: 14, color: Color(0xFF8A8FA3)),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final VoidCallback onGoToQueue;

  const _BookingCard({required this.booking, required this.onGoToQueue});

  @override
  Widget build(BuildContext context) {
    final serviceName = (booking['serviceName'] as String? ?? '—').localizedApi;
    final orgName = (booking['orgName'] as String? ?? '—').localizedApi;
    final branchName = (booking['branchName'] as String? ?? '').localizedApi;
    final slotStartRaw = booking[BookingKeys.slotStart] as String?;
    final slotStartTime = booking[BookingKeys.slotStartTime] as String? ?? '—';

    String? formattedDate;
    if (slotStartRaw != null) {
      final dt = DateTime.tryParse(slotStartRaw);
      if (dt != null) {
        formattedDate = DateFormat('d MMM yyyy').format(dt);
      }
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFEEFEFF),
            const Color(0xFFD6F9F7).withAlpha(120),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF1A9E7A).withAlpha(40),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF1A9E7A).withAlpha(30),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.access_time_rounded,
              color: Color(0xFF1A9E7A),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  serviceName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  orgName + (branchName.isNotEmpty ? ' · $branchName' : ''),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF5A6175),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: Color(0xFF8A8FA3),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      formattedDate ?? '—',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8A8FA3),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.schedule_rounded,
                      size: 11,
                      color: Color(0xFF8A8FA3),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      slotStartTime,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF8A8FA3),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
