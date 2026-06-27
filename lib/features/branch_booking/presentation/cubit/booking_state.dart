part of 'booking_cubit.dart';

@immutable
sealed class BookingState {}

final class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final AppointmentResponseModel appointment;

  BookingSuccess(this.appointment);
}

class BookingError extends BookingState {
  final String message;
  BookingError(this.message);
}

class SlotsInitial extends BookingState {}

class SlotsLoading extends BookingState {}

class SlotsLoaded extends BookingState {
  final List slots;
  SlotsLoaded(this.slots);
}

class SlotsError extends BookingState {
  final String message;
  SlotsError(this.message);
}

// Payment States
class PaymentIntentLoading extends BookingState {}

class PaymentIntentSuccess extends BookingState {
  final String clientSecret;
  final AppointmentResponseModel appointment;

  PaymentIntentSuccess({
    required this.clientSecret,
    required this.appointment,
  });
}

class PaymentIntentError extends BookingState {
  final String message;
  PaymentIntentError(this.message);
}

class PaymentCompleted extends BookingState {
  final AppointmentResponseModel appointment;
  PaymentCompleted(this.appointment);
}

class PaymentCancelled extends BookingState {}
