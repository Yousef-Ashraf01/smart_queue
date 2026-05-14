part of 'service_counter_cubit.dart';

@immutable
sealed class ServiceCounterState {}

class ServiceCounterInitial extends ServiceCounterState {}

class ServiceCounterLoading extends ServiceCounterState {}

class ServiceCounterLoaded extends ServiceCounterState {
  final List<ServiceCounterModel> serviceCounter;
  ServiceCounterLoaded(this.serviceCounter);
}

class ServiceCounterError extends ServiceCounterState {
  final String message;
  ServiceCounterError(this.message);
}
