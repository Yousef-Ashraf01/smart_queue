part of 'services_cubit.dart';

@immutable
sealed class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesLoaded extends ServicesState {
  final List<ServiceModel> services;
  ServicesLoaded(this.services);
}

class ServicesError extends ServicesState {
  final String message;
  ServicesError(this.message);
}
