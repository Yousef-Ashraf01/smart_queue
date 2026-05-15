import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/map/data/repositories/branch_repository.dart';

part 'branch_state.dart';

class BranchCubit extends Cubit<BranchState> {
  final BranchRepository repository;

  BranchCubit(this.repository) : super(BranchInitial());

  Future<void> fetchBranches(int orgId) async {
    emit(BranchLoading());

    final result = await repository.getBranches(orgId);

    result.fold(
      (failure) => emit(BranchError(failure.message)),
      (data) => emit(BranchLoaded(data)),
    );
  }
}
