import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/branch_booking/data/models/appointment_model.dart';
import 'package:smart_queue/features/branch_booking/data/repositories/booking_repository.dart';

part 'operations_state.dart';

class OperationsCubit extends Cubit<OperationsState> {
  final BookingRepository repository;

  OperationsCubit(this.repository) : super(OperationsInitial());

  int currentPage = 1;
  bool hasMore = true;
  String? nextUrl;
  List<AppointmentModel> allOperations = [];

  Future<void> fetchOperations() async {
    emit(OperationsLoading());

    allOperations.clear();

    final result = await repository.getOperations(null);

    result.fold((failure) => emit(OperationsError(failure.message)), (data) {
      allOperations = data.items;
      nextUrl = data.nextUrl;

      emit(
        OperationsLoaded(operations: allOperations, hasMore: nextUrl != null),
      );
    });
  }

  bool isLoadingMore = false;

  Future<void> loadMore() async {
    if (nextUrl == null || isLoadingMore) return;

    isLoadingMore = true;

    emit(
      OperationsLoaded(
        operations: allOperations,
        hasMore: true,
        isLoadingMore: true,
      ),
    );

    final result = await repository.getOperations(nextUrl);

    result.fold(
      (failure) {
        isLoadingMore = false;
        emit(OperationsError(failure.message));
      },
      (data) {
        allOperations.addAll(data.items);
        nextUrl = data.nextUrl;
        isLoadingMore = false;

        emit(
          OperationsLoaded(operations: allOperations, hasMore: nextUrl != null),
        );
      },
    );
  }
}
