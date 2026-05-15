import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/app_settings/change_password/data/repositories/change_password_repository.dart';

part 'change_password_state.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  final ChangePasswordRepository repository;

  ChangePasswordCubit(this.repository) : super(ChangePasswordInitial());

  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    emit(ChangePasswordLoading());

    final result = await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(ChangePasswordError(failure.message)),
      (_) => emit(ChangePasswordSuccess()),
    );
  }
}
