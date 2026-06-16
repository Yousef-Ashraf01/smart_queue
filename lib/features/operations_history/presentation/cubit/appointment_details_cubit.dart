import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_response_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';
import 'package:smart_queue/features/operations_history/presentation/cubit/feedback_cubit.dart';

part 'appointment_details_state.dart';

class AppointmentDetailsCubit extends Cubit<AppointmentDetailsState> {
  final BookingRepository repository;
  final FeedbackCubit feedbackCubit;

  AppointmentDetailsCubit(this.repository, this.feedbackCubit)
    : super(AppointmentDetailsInitial());

  Future<void> fetchById(int id) async {
    emit(AppointmentDetailsLoading());

    final result = await repository.getRequestById(id);

    result.fold(
      (failure) => emit(AppointmentDetailsError(failure.message)),
      (data) => emit(AppointmentDetailsLoaded(data)),
    );
  }

  Future<void> delete(int appointmentId) async {
    emit(AppointmentDeleting());
    try {
      await feedbackCubit.deleteFeedbackIfExists(appointmentId);

      final result = await repository.deleteRequest(appointmentId);
      result.fold(
        (failure) => emit(AppointmentDetailsError(failure.message)),
        (_) => emit(AppointmentDeleted()),
      );
    } catch (e) {
      emit(AppointmentDetailsError(e.toString()));
    }
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
