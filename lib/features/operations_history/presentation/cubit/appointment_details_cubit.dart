import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final BookingRepository repository;

  AppointmentDetailsCubit(this.repository) : super(AppointmentDetailsInitial());

  Future<void> fetchById(int id) async {
    emit(AppointmentDetailsLoading());

    final result = await repository.getRequestById(id);

    result.fold(
      (failure) => emit(AppointmentDetailsError(failure.message)),
      (data) => emit(AppointmentDetailsLoaded(data)),
    );
  }

  Future<void> delete(int id) async {
    emit(AppointmentDeleting());

    final result = await repository.deleteRequest(id);

    result.fold(
      (failure) => emit(AppointmentDetailsError(failure.message)),
      (_) => emit(AppointmentDeleted()),
    );
  }

  Future<void> update(int id, AppointmentResponseModel model) async {
    emit(AppointmentUpdating());

    final updateResult = await repository.updateRequest(id, model);

    await updateResult.fold(
      (failure) async {
        emit(AppointmentDetailsError(failure.message));
      },
      (_) async {
        final fetchResult = await repository.getRequestById(id);

        fetchResult.fold(
          (failure) => emit(AppointmentDetailsError(failure.message)),
          (data) => emit(AppointmentDetailsLoaded(data)),
        );
      },
    );
  }

  void updateLocally(AppointmentResponseModel model) {
    emit(AppointmentDetailsLoaded(model));
  }
}
