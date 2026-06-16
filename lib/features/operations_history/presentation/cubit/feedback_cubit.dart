import 'package:bloc/bloc.dart';
import 'package:smart_queue/features/operations_history/data/models/feedback_model.dart';
import 'package:smart_queue/features/operations_history/data/repositories/feedback_repository.dart';

part 'feedback_state.dart';

class FeedbackCubit extends Cubit<FeedbackState> {
  final FeedbackRepository repository;
  int? _submittedFeedbackId;

  FeedbackCubit(this.repository) : super(FeedbackInitial());

  Future<void> loadFeedback(int appointmentId) async {
    emit(FeedbackLoading());
    final result = await repository.getFeedback(appointmentId);
    result.fold(
      (failure) => emit(FeedbackError(failure.message)),
      (feedback) => emit(FeedbackLoaded(feedback)),
    );
  }

  Future<void> submitFeedback({
    required int appointmentId,
    required String feedback,
  }) async {
    emit(FeedbackSubmitting());
    final result = await repository.submitFeedback(
      appointmentId: appointmentId,
      feedback: feedback,
    );
    result.fold((failure) => emit(FeedbackError(failure.message)), (model) {
      _submittedFeedbackId = model.id;
      emit(FeedbackSubmitted(model));
    });
  }

  Future<void> deleteFeedbackIfExists(int appointmentId) async {
    if (_submittedFeedbackId != null) {
      await repository.deleteFeedback(
        appointmentId: appointmentId,
        feedbackId: _submittedFeedbackId,
      );
      _submittedFeedbackId = null;
    }
  }
}
