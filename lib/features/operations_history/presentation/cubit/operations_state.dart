part of 'operations_cubit.dart';

@immutable
sealed class OperationsState {}

final class OperationsInitial extends OperationsState {}

class OperationsLoading extends OperationsState {}

class OperationsLoaded extends OperationsState {
  final List<AppointmentModel> operations;
  final bool hasMore;
  final bool isLoadingMore;

  OperationsLoaded({
    required this.operations,
    required this.hasMore,
    this.isLoadingMore = false,
  });
}

class OperationsError extends OperationsState {
  final String message;

  OperationsError(this.message);
}
