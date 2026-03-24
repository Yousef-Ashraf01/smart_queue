import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';

import '../../data/repositories/personal_info_repository.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  final PersonalInfoRepository repository;

  PersonalInfoCubit(this.repository) : super(PersonalInfoInitial());

  Future<void> getProfile() async {
    emit(PersonalInfoLoading());

    final result = await repository.getProfile();

    result.fold(
      (failure) => emit(PersonalInfoError(failure.message)),
      (profile) => emit(PersonalInfoLoaded(profile)),
    );
  }

  Future<void> updateProfile(ProfileModel profile) async {
    emit(PersonalInfoUpdating());

    final result = await repository.updateProfile(profile);

    result.fold(
      (failure) {
        emit(PersonalInfoError(failure.message));
      },
      (updatedProfile) {
        emit(PersonalInfoUpdated(updatedProfile));
        emit(PersonalInfoLoaded(updatedProfile));
      },
    );
  }
}
