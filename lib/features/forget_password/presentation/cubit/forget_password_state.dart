part of 'forget_password_cubit.dart';

sealed class ForgetPasswordState {}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordRequestSuccess extends ForgetPasswordState {}

class ForgetPasswordConfirmSuccess extends ForgetPasswordState {}

class ForgetPasswordVerifySuccess extends ForgetPasswordState {
  final String sessionToken;
  ForgetPasswordVerifySuccess(this.sessionToken);
}

class ForgetPasswordError extends ForgetPasswordState {
  final String message;
  ForgetPasswordError(this.message);
}

class RegisterVerifySuccess extends ForgetPasswordState {
  final String verificationToken;
  RegisterVerifySuccess(this.verificationToken);
}

class RegisterSmsRequestSuccess extends ForgetPasswordState {}
