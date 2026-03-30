import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'services_state.dart';

class ServicesCubit extends Cubit<ServicesState> {
  final BookingRepository repository;

  ServicesCubit(this.repository) : super(ServicesInitial());

  Future<void> fetchServices() async {
    emit(ServicesLoading());

    final result = await repository.getServices();

    result.fold(
      (failure) => emit(ServicesError(failure.message)),
      (services) => emit(ServicesLoaded(services)),
    );
  }
}
