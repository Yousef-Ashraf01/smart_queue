import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_queue/core/utils/booking_keys.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'active_booking_state.dart';

class ActiveBookingCubit extends Cubit<ActiveBookingState> {
  final BookingRepository repository;

  ActiveBookingCubit(this.repository) : super(ActiveBookingInitial()) {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> list = prefs.getStringList('active_bookings_list') ?? [];

    if (list.isEmpty) {
      // Check legacy single-booking keys and migrate them if present
      final slotStart = prefs.getString(BookingKeys.slotStartOnly);
      final slotEnd = prefs.getString(BookingKeys.slotEnd);
      final bookingDate = prefs.getString(BookingKeys.bookingDate);
      final appointmentId = prefs.getInt(BookingKeys.appointmentId);
      final counterId = prefs.getInt(BookingKeys.counterId);

    if (slotStart == null ||
        appointmentId == null ||
        counterId == null ||
        slotEnd == null ||
        bookingDate == null) {
      emit(ActiveBookingInitial());
      return;
    }

    // active_booking_cubit.dart
    emit(
      ActiveBookingLoaded({
        "id": appointmentId,
        "counterId": counterId,
        "branchName": prefs.getString(BookingKeys.branchName),
        "branchAddress": prefs.getString(BookingKeys.branchAddress),
        "serviceName": prefs.getString(BookingKeys.serviceName),
        "serviceDesc": prefs.getString(BookingKeys.serviceDesc),
        BookingKeys.slotStart: prefs.getString(BookingKeys.slotStart),
        BookingKeys.slotEnd: prefs.getString(BookingKeys.slotEnd),
        "createdAt": prefs.getString(BookingKeys.createdAt),
        BookingKeys.slotStartTime: prefs.getString(BookingKeys.slotStartOnly),
        BookingKeys.bookingDate: prefs.getString(BookingKeys.bookingDate),
        "serviceId": prefs.getInt(BookingKeys.serviceId),
      }),
    );
  }

  void setBooking(Map<String, dynamic> data) {
    emit(ActiveBookingLoaded(data));
  }

  void clearBooking() {
    emit(ActiveBookingInitial());
  }

  Future<void> cancelBooking(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final appointmentId = id.toString();

    final cancelledIds = prefs.getStringList(BookingKeys.cancelledIds) ?? [];

    if (cancelledIds.contains(appointmentId)) {
      emit(
        ActiveBookingError("You already cancelled this appointment before."),
      );
      return;
    }

    emit(ActiveBookingCancelling());

    final result = await repository.cancelAppointment(id);

    result.fold((failure) => emit(ActiveBookingError(failure.message)), (
      _,
    ) async {
      cancelledIds.add(appointmentId);
      await prefs.setStringList(BookingKeys.cancelledIds, cancelledIds);

      await prefs.remove(BookingKeys.appointmentId);
      await prefs.remove(BookingKeys.counterId);
      await prefs.remove(BookingKeys.serviceId);
      await prefs.remove(BookingKeys.slotStartTime);
      await prefs.remove(BookingKeys.slotStart);
      await prefs.remove(BookingKeys.bookingDate);
      await prefs.remove(BookingKeys.branchName);
      await prefs.remove(BookingKeys.branchAddress);
      await prefs.remove(BookingKeys.serviceName);
      await prefs.remove(BookingKeys.serviceDesc);
      await prefs.remove(BookingKeys.createdAt);
      await prefs.remove(BookingKeys.slotStartOnly);

      emit(ActiveBookingCancelled());
    });
  }
}
