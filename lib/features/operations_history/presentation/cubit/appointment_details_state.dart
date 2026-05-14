part of 'appointment_details_cubit.dart';

@immutable
sealed class AppointmentDetailsState {}

class AppointmentDetailsInitial extends AppointmentDetailsState {}

class AppointmentDetailsLoading extends AppointmentDetailsState {}

class AppointmentDetailsLoaded extends AppointmentDetailsState {
  final AppointmentResponseModel appointment;

  AppointmentDetailsLoaded(this.appointment);
}

class AppointmentDetailsError extends AppointmentDetailsState {
  final String message;

  AppointmentDetailsError(this.message);
}

class AppointmentDeleting extends AppointmentDetailsState {}

class AppointmentDeleted extends AppointmentDetailsState {}

class AppointmentUpdating extends AppointmentDetailsState {}

class AppointmentUpdated extends AppointmentDetailsState {}
