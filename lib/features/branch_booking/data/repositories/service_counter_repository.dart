import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/branch_booking/data/datasources/service_counter_remote_data_source.dart';
import 'package:smart_queue/features/branch_booking/data/models/service_counter_model.dart';

class ServiceCounterRepository {
  final ServiceCounterRemoteDataSource remote;

  ServiceCounterRepository(this.remote);

  Future<Either<Failure, List<ServiceCounterModel>>> getServiceCounters(
    int branchId,
  ) async {
    try {
      final result = await remote.getServiceCounters(branchId);
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
