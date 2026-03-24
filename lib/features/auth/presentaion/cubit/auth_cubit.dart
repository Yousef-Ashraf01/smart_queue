import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/profile_model.dart';
import '../../data/models/register_request_model.dart';
import '../../data/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repository;

  AuthCubit(this.repository) : super(AuthInitial());

  Future<void> register(RegisterRequestModel request) async {
    emit(AuthLoading());

    final result = await repository.register(request);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (profile) => emit(RegisterSuccess(profile)),
    );
  }

  Future<void> login(String nationalId, String password) async {
    emit(AuthLoading());

    final result = await repository.login(nationalId, password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(LoginSuccess()),
    );
  }

  Future<void> checkAuthStatus() async {
    // emit(AuthLoading());

    final access = await repository.remote.storage.getAccessToken();

    if (access != null) {
      emit(LoginSuccess());
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> logout() async {
    await repository.logout();
    emit(AuthInitial());
  }
}
