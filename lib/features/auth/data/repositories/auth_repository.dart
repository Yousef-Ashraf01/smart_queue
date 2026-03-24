import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/auth/data/datasources/auth_remote_data_source.dart';

import '../models/profile_model.dart';
import '../models/register_request_model.dart';

class AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepository(this.remote);

  Future<Either<Failure, ProfileModel>> register(
    RegisterRequestModel request,
  ) async {
    try {
      final result = await remote.register(request);
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> login(
    String nationalId,
    String password,
  ) async {
    try {
      await remote.login(nationalId: nationalId, password: password);
      return const Right(unit);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, Unit>> logout() async {
    try {
      await remote.logout();
      return const Right(unit);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
