part of 'feedback_cubit.dart';

abstract class FeedbackState {}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackLoaded extends FeedbackState {
  final List<FeedbackModel> feedbacks;
  FeedbackLoaded(this.feedbacks);
}

class FeedbackSubmitting extends FeedbackState {}

class FeedbackSubmitted extends FeedbackState {
  final FeedbackModel feedback;
  FeedbackSubmitted(this.feedback);
}

class FeedbackError extends FeedbackState {
  final String message;
  FeedbackError(this.message);
}
