import 'package:smart_queue/features/auth/data/models/profile_model.dart';

abstract class PersonalInfoState {}

class PersonalInfoInitial extends PersonalInfoState {}

class PersonalInfoLoading extends PersonalInfoState {}

class PersonalInfoLoaded extends PersonalInfoState {
  final ProfileModel profile;

  PersonalInfoLoaded(this.profile);
}

class PersonalInfoError extends PersonalInfoState {
  final String message;

  PersonalInfoError(this.message);
}

class PersonalInfoUpdating extends PersonalInfoState {}

class PersonalInfoUpdated extends PersonalInfoState {
  final ProfileModel profile;
  PersonalInfoUpdated(this.profile);
}
