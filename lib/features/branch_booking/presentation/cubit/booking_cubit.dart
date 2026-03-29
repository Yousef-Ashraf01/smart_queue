import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_request_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;

  BookingCubit(this.repository) : super(BookingInitial());

  Future<void> bookAppointment({
    required AppointmentRequestModel request,
    required AppointmentModel appointment,
  }) async {
    emit(BookingLoading());

    // 1️⃣ create request
    final requestResult = await repository.createRequest(request);

    await requestResult.fold(
      (failure) async => emit(BookingError(failure.message)),
      (requestId) async {
        // 2️⃣ create appointment باستخدام ID
        final updatedAppointment = AppointmentModel(
          appointmentRequest: requestId,
          phone: appointment.phone,
          address: appointment.address,
          wantReminder: appointment.wantReminder,
          additionalInfo: appointment.additionalInfo,
          paid: appointment.paid,
          amountToPay: appointment.amountToPay,
        );

        final result = await repository.createAppointment(updatedAppointment);

        result.fold(
          (failure) => emit(BookingError(failure.message)),
          (_) => emit(BookingSuccess()),
        );
      },
    );
  }
}
