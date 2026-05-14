import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository repository;

  BookingCubit(this.repository) : super(BookingInitial());

  Future<void> bookAppointment({required AppointmentModel appointment}) async {
    emit(BookingLoading());

    final result = await repository.createAppointment(appointment);

    result.fold(
      (failure) => emit(BookingError(failure.message)),
      (_) => emit(BookingSuccess()),
    );
  }

  Future<void> getSlots({required int counterId, required String date}) async {
    emit(SlotsLoading());

    final result = await repository.getAvailableSlots(
      counterId: counterId,
      date: date,
    );

    result.fold(
      (failure) => emit(SlotsError(failure.message)),
      (slots) => emit(SlotsLoaded(slots)),
    );
  }
}
