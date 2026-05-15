import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/map/data/datasources/branch_remote_data_source.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';

class BranchRepository {
  final BranchRemoteDataSource remote;

  BranchRepository(this.remote);

  Future<Either<Failure, List<BranchModel>>> getBranches(int orgId) async {
    try {
      final result = await remote.getBranches(orgId);
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
