part of 'active_booking_cubit.dart';

abstract class ActiveBookingState {}

class ActiveBookingInitial extends ActiveBookingState {}

class ActiveBookingLoaded extends ActiveBookingState {
  final Map<String, dynamic> booking;

  ActiveBookingLoaded(this.booking);
}

class ActiveBookingCancelling extends ActiveBookingState {}

class ActiveBookingCancelled extends ActiveBookingState {}

class ActiveBookingError extends ActiveBookingState {
  final String message;

  ActiveBookingError(this.message);
}
