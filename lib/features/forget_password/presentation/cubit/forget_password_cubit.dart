import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/features/auth/data/repositories/auth_repository.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository repository;

  ForgetPasswordCubit(this.repository) : super(ForgetPasswordInitial());

  Future<void> resetPasswordRequest(String phone) async {
    emit(ForgetPasswordLoading());

    final result = await repository.resetPasswordRequest(phone);

    result.fold(
      (failure) => emit(ForgetPasswordError(failure.message)),
      (_) => emit(ForgetPasswordRequestSuccess()),
    );
  }

  Future<void> verifySmsCode({
    required String phone,
    required String code,
  }) async {
    emit(ForgetPasswordLoading());

    final result = await repository.verifySmsCode(
      phone: phone,
      code: code,
      purpose: 'reset_password',
    );

    result.fold(
      (failure) => emit(ForgetPasswordError(failure.message)),
      (token) => emit(ForgetPasswordVerifySuccess(token ?? '')),
    );
  }

  Future<void> registerSmsRequest(String phone) async {
    emit(ForgetPasswordLoading());

    final result = await repository.registerSmsRequest(phone);

    result.fold(
      (failure) => emit(ForgetPasswordError(failure.message)),
      (_) => emit(RegisterSmsRequestSuccess()),
    );
  }

  Future<void> verifyRegisterSmsCode({
    required String phone,
    required String code,
  }) async {
    emit(ForgetPasswordLoading());
    final result = await repository.verifySmsCode(
      phone: phone,
      code: code,
      purpose: 'register',
    );

    result.fold(
      (failure) => emit(ForgetPasswordError(failure.message)),
      (token) => emit(RegisterVerifySuccess(token ?? '')),
    );
  }

  Future<void> resetPasswordConfirm({
    required String sessionToken,
    required String newPassword,
  }) async {
    emit(ForgetPasswordLoading());

    final result = await repository.resetPasswordConfirm(
      sessionToken: sessionToken,
      newPassword: newPassword,
    );

    result.fold(
      (failure) => emit(ForgetPasswordError(failure.message)),
      (_) => emit(ForgetPasswordConfirmSuccess()),
    );
  }
}
