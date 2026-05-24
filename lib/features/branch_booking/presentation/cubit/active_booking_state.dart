part of 'active_booking_cubit.dart';

abstract class ActiveBookingState {}

class ActiveBookingInitial extends ActiveBookingState {}

class ActiveBookingLoaded extends ActiveBookingState {
  final List<Map<String, dynamic>> bookings;

  ActiveBookingLoaded(this.bookings);
}

class ActiveBookingCancelling extends ActiveBookingState {}

class ActiveBookingCancelled extends ActiveBookingState {}

class ActiveBookingError extends ActiveBookingState {
  final String message;

  ActiveBookingError(this.message);
}
