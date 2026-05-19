part of 'id_cubit.dart';

@immutable
sealed class IdState {}

final class IdInitial extends IdState {}

class IdLoading extends IdState {}

class IdSuccess extends IdState {
  final IdExtractModel data;

  IdSuccess(this.data);
}

class IdError extends IdState {
  final String message;

  IdError(this.message);
}
