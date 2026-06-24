import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/core/storage/secure_storage_service.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model.dart';
import 'package:smart_queue/features/auth/data/models/register_request_model_extension.dart';

import '../models/auth_token_model.dart';
import '../models/profile_model.dart';

class AuthRemoteDataSource {
  final Dio dio;
  final SecureStorageService storage;

  AuthRemoteDataSource(this.dio, this.storage);

  Future<ProfileModel> register(RegisterRequestModel request) async {
    final response = await dio.post(
      ApiEndpoints.register,
      data: await request.toFormData(),
      options: Options(contentType: 'multipart/form-data'),
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

  Future<void> resetPasswordRequest({required String phone}) async {
    await dio.post(
      ApiEndpoints.resetPasswordRequest,
      data: {"phone": phone},
    );
  }

  Future<void> registerSmsRequest({required String phone}) async {
    await dio.post(
      ApiEndpoints.registerSmsRequest,
      data: {"phone": phone},
    );
  }

  Future<String?> verifySmsCode({
    required String phone,
    required String code,
    required String purpose,
  }) async {
    final response = await dio.post(
      ApiEndpoints.verifySmsCode,
      data: {
        "phone": phone,
        "code": code,
        "purpose": purpose,
      },
    );
    // API returns session_token for reset_password and verification_token for register
    return (response.data['verification_token'] ??
        response.data['session_token']) as String?;
  }

  Future<void> resetPasswordConfirm({
    required String sessionToken,
    required String newPassword,
  }) async {
    await dio.post(
      ApiEndpoints.resetPasswordConfirm,
      data: {
        "session_token": sessionToken,
        "new_password": newPassword,
      },
    );
  }
}
