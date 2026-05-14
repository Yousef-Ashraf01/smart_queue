import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';

class ChangePasswordRemoteDataSource {
  final Dio dio;

  ChangePasswordRemoteDataSource(this.dio);

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await dio.post(
      ApiEndpoints.changePassword,
      data: {"current_password": currentPassword, "new_password": newPassword},
    );
  }
}
