import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:smart_queue/core/networking/api_constant.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/core/storage/secure_storage_service.dart';

class DioClient {
  final Dio dio;
  final SecureStorageService storageService;

  bool _isRefreshing = false;

  DioClient(this.dio, this.storageService) {
    dio.options.baseUrl = ApiConstants.baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final access = await storageService.getAccessToken();
          if (access != null) {
            options.headers[ApiConstants.authorizationHeader] = 'JWT $access';
          }
          return handler.next(options);
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401 &&
              !_isRefreshing &&
              error.requestOptions.path != ApiEndpoints.refreshToken) {
            _isRefreshing = true;

            try {
              final newAccess = await _refreshToken();

              _isRefreshing = false;

              final requestOptions = error.requestOptions;

              requestOptions.headers[ApiConstants.authorizationHeader] =
                  'JWT $newAccess';

              final clonedResponse = await dio.request(
                requestOptions.path,
                data: requestOptions.data,
                queryParameters: requestOptions.queryParameters,
                options: Options(
                  method: requestOptions.method,
                  headers: requestOptions.headers,
                ),
              );

              return handler.resolve(clonedResponse);
            } catch (e) {
              _isRefreshing = false;
              await storageService.clearTokens();
              return handler.next(error);
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  Future<String> _refreshToken() async {
    final refresh = await storageService.getRefreshToken();
    if (refresh == null) throw Exception("No refresh token");

    final response = await dio.post(
      ApiEndpoints.refreshToken,
      data: {"refresh": refresh},
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final newAccess = response.data['access'];

    await storageService.saveAccessToken(newAccess);

    return newAccess;
  }
}
