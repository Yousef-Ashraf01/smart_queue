import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/auth/data/models/profile_model.dart';

import '../datasources/personal_info_remote_data_source.dart';

class PersonalInfoRepository {
  final PersonalInfoRemoteDataSource remote;

  PersonalInfoRepository(this.remote);

  Future<Either<Failure, ProfileModel>> getProfile() async {
    try {
      final result = await remote.getProfile();
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileModel profile,
  ) async {
    try {
      final result = await remote.updateProfile(profile);
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
