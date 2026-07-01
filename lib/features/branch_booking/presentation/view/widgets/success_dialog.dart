import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/theme/app_theme.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/timer/presentation/veiw/timer_screen.dart';

class BookingSuccessDialog extends StatelessWidget {
  final int hours;
  final int minutes;
  final Duration difference;
  final DateTime slotStart;
  final AppointmentResponseModel appointment;
  final BranchModel branch;
  final ServiceCounterModel selectedService;
  final Map<String, String> selectedSlot;
  final VoidCallback? onViewBookings;

  const BookingSuccessDialog({
    super.key,
    required this.hours,
    required this.minutes,
    required this.difference,
    required this.slotStart,
    required this.appointment,
    required this.branch,
    required this.selectedService,
    required this.selectedSlot,
    this.onViewBookings,
  });

  @override
  Widget build(BuildContext context) {
    final ext = context.appTheme;
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: ext.cardColor,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: ext.cardBorder),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFE1F5EE),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xFF1A9E7A),
                size: 36,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              'booking_confirmed'.tr(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              'booking_confirmed_desc'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: ext.subtleText,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: ext.cardBorder.withOpacity(0.35),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F5EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.access_time_rounded,
                          color: Color(0xFF1A9E7A),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'estimated_wait'.tr(),
                            style: TextStyle(
                              fontSize: 11,
                              color: ext.subtleText,
                            ),
                          ),
                          Text(
                            hours > 0 ? '${hours}h ${minutes}m' : '${minutes}m',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F5EE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'active'.tr(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF085041),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1, color: ext.cardBorder),
                  ),
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1F5EE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.confirmation_number_outlined,
                          color: Color(0xFF1A9E7A),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'appointment_id'.tr(),
                            style: TextStyle(
                              fontSize: 11,
                              color: ext.subtleText,
                            ),
                          ),
                          Text(
                            '#${appointment.id}',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onGoHome(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A9E7A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'go_to_home'.tr(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            // const SizedBox(height: 8),

            // SizedBox(
            //   width: double.infinity,
            //   child: OutlinedButton(
            //     onPressed: () {
            //       context.pop();
            //       context.go(AppRoutes.main);
            //     },
            //     style: OutlinedButton.styleFrom(
            //       foregroundColor: ext.subtleText,
            //       side: BorderSide(color: ext.cardBorder),
            //       padding: const EdgeInsets.symmetric(vertical: 13),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(16),
            //       ),
            //     ),
            //     child: Text(
            //       'maybe_later'.tr(),
            //       style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _onGoHome(BuildContext context) {
    TimerScreen.pendingDuration = difference;
    context.pop();
    context.go(AppRoutes.main);
  }
}
