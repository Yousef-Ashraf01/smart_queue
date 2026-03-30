import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/home/data/datasources/organization_remote_data_source.dart';
import 'package:smart_queue/features/home/data/models/organization_model.dart';

class OrganizationRepository {
  final OrganizationRemoteDataSource remote;

  OrganizationRepository(this.remote);

  Future<Either<Failure, List<OrganizationModel>>> getOrganizations() async {
    try {
      final result = await remote.getOrganizations();
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
