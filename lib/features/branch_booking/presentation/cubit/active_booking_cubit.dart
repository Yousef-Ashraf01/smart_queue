import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'active_booking_state.dart';

class ActiveBookingCubit extends Cubit<ActiveBookingState> {
  final BookingRepository repository;

  ActiveBookingCubit(this.repository) : super(ActiveBookingInitial()) {
    loadFromPrefs();
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    final slotStart = prefs.getString('slot_start_time');
    final appointmentId = prefs.getInt('appointmentId');
    final counterId = prefs.getInt('counterId');

    if (slotStart == null || appointmentId == null || counterId == null) {
      emit(ActiveBookingInitial());
      return;
    }

    emit(
      ActiveBookingLoaded({
        "id": appointmentId,
        "counterId": counterId,
        "branchName": prefs.getString('branchName'),
        "branchAddress": prefs.getString('branchAddress'),
        "serviceName": prefs.getString('serviceName'),
        "serviceDesc": prefs.getString('serviceDesc'),
        "slotStart": slotStart,
        "createdAt": prefs.getString('createdAt'),
        "slotStartTime": prefs.getString('slot_start_only'),
      }),
    );
  }

  void setBooking(Map<String, dynamic> data) {
    emit(ActiveBookingLoaded(data));
  }

  void clearBooking() {
    emit(ActiveBookingInitial());
  }

  Future<void> cancelBooking(int id, int counterId, String startTime) async {
    final prefs = await SharedPreferences.getInstance();

    emit(ActiveBookingCancelling());

    final result = await repository.cancelAppointment(id, counterId, startTime);

    result.fold(
      (failure) {
        emit(ActiveBookingError(failure.message));
      },
      (_) async {
        await prefs.remove('appointmentId');
        await prefs.remove('counterId');
        await prefs.remove('slot_start_time');
        await prefs.remove('branchName');
        await prefs.remove('branchAddress');
        await prefs.remove('serviceName');
        await prefs.remove('serviceDesc');
        await prefs.remove('createdAt');
        await prefs.remove('slot_start_only');

        emit(ActiveBookingCancelled());
      },
    );
  }
}
