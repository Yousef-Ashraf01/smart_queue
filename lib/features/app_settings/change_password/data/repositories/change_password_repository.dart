import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/app_settings/change_password/data/datasources/change_password_remote_data_source.dart';

class ChangePasswordRepository {
  final ChangePasswordRemoteDataSource remote;

  ChangePasswordRepository(this.remote);

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remote.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      return const Right(null);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
