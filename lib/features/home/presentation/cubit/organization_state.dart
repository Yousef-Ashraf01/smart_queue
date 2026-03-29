part of 'organization_cubit.dart';

@immutable
sealed class OrganizationState {}

final class OrganizationInitial extends OrganizationState {}

class OrganizationsLoading extends OrganizationState {}

class OrganizationsLoaded extends OrganizationState {
  final List<OrganizationModel> organizations;

  OrganizationsLoaded(this.organizations);
}

class OrganizationsError extends OrganizationState {
  final String message;
  OrganizationsError(this.message);
}
