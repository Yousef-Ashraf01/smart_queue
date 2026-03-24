import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/core/storage/secure_storage_service.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';

import '../models/auth_token_model.dart';
import '../models/profile_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final SecureStorageService storage;

  AuthRemoteDataSource(this.dio, this.storage);

  Future<ProfileModel> register(RegisterRequestModel request) async {
    final response = await dio.post(
      ApiEndpoints.register,
      data: request.toJson(),
    );

    return ProfileModel.fromJson(response.data);
  }

  Future<void> login({
    required String nationalId,
    required String password,
  }) async {
    final response = await dio.post(
      ApiEndpoints.login,
      data: {"national_id": nationalId, "password": password},
    );

    final tokens = AuthTokenModel.fromJson(response.data);

    await storage.saveAccessToken(tokens.access);
    await storage.saveRefreshToken(tokens.refresh);
  }

  Future<void> logout() async {
    await storage.clearTokens();
  }
}
