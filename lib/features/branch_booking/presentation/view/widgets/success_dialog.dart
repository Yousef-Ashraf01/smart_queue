import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
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
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.green, size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              "Booking Confirmed 🎉",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Your appointment has been successfully booked.\nYou can view it from your bookings.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              hours > 0
                  ? "⏳ Estimated wait: ${hours}h ${minutes}m"
                  : "⏳ Estimated wait: ${minutes}m",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _onGoHome(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Go To Home",
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ),
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
