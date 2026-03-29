import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/home/data/models/organization_model.dart';
import 'package:smart_queue/features/home/data/repositories/organization_repository.dart';

part 'organization_state.dart';

class OrganizationsCubit extends Cubit<OrganizationState> {
  final OrganizationRepository repository;

  OrganizationsCubit(this.repository) : super(OrganizationInitial());

  Future<void> fetchOrganizations() async {
    emit(OrganizationsLoading());

    final result = await repository.getOrganizations();

    result.fold(
      (failure) => emit(OrganizationsError(failure.message)),
      (data) => emit(OrganizationsLoaded(data)),
    );
  }
}
