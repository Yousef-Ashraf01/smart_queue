import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';
import 'package:smart_queue/features/branch_booking/presentation/cubit/active_booking_cubit.dart';
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

    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(BookingKeys.appointmentId, appointment.id);
      prefs.setInt(BookingKeys.counterId, appointment.counter.id);
      prefs.setString(
        BookingKeys.slotStart,
        slotStart.toIso8601String(),
      ); // ✅ "slot_start"
      prefs.setString(
        BookingKeys.slotStartOnly,
        "${selectedSlot['start']}",
      ); // ✅ "slot_start_only"
      prefs.setString(
        BookingKeys.slotEnd,
        "${selectedSlot['end']}",
      ); // ✅ "slot_end"
      prefs.setString(BookingKeys.branchName, branch.name);
      prefs.setString(BookingKeys.branchAddress, branch.address ?? "");
      prefs.setString(BookingKeys.serviceName, selectedService.serviceName);
      prefs.setString(
        BookingKeys.serviceDesc,
        selectedService.serviceDescription,
      );
      prefs.setString(BookingKeys.createdAt, DateTime.now().toIso8601String());
      prefs.setInt(BookingKeys.serviceId, selectedService.serviceId);
    });

    context.read<ActiveBookingCubit>().setBooking({
      BookingKeys.appointmentId: appointment.id, // ✅ "id"
      BookingKeys.counterId: appointment.counter.id, // ✅ "counterId"
      BookingKeys.branchName: branch.name,
      BookingKeys.branchAddress: branch.address,
      BookingKeys.serviceName: appointment.counter.service.name,
      BookingKeys.serviceDesc: appointment.counter.service.description,
      BookingKeys.slotStart: slotStart.toIso8601String(), // ✅ أضفه
      BookingKeys.slotStartTime:
          "${selectedSlot['start']}:00", // = "08:20:00" ✅
      BookingKeys.slotEnd: "${selectedSlot['end']}:00", // = "08:30:00" ✅
      BookingKeys.createdAt: DateTime.now().toIso8601String(),
      BookingKeys.serviceId: selectedService.serviceId,
    });

    context.pop();
    context.go(AppRoutes.main);
  }
}
