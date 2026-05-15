import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/service_counter_repository.dart';

part 'service_counter_state.dart';

class ServiceCounterCubit extends Cubit<ServiceCounterState> {
  final ServiceCounterRepository repository;

  ServiceCounterCubit(this.repository) : super(ServiceCounterInitial());

  Future<void> fetchServiceCounters(int branchId) async {
    emit(ServiceCounterLoading());

    final result = await repository.getServiceCounters(branchId);

    result.fold(
      (failure) => emit(ServiceCounterError(failure.message)),
      (data) => emit(ServiceCounterLoaded(data)),
    );
  }
}
