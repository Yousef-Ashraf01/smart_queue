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
