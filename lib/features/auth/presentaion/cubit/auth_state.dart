part of 'auth_cubit.dart';

abstract class AuthState {
  bool get isLoading => false;
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {
  @override
  bool get isLoading => true;
}

class RegisterSuccess extends AuthState {
  final ProfileModel profile;
  RegisterSuccess(this.profile);
}

class RegisterOtpSentSuccess extends AuthState {
  final String phone;
  RegisterOtpSentSuccess(this.phone);
}

class LoginSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}
