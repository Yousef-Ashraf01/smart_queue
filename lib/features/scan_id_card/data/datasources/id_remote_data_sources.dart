import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';

class IdRemoteDataSource {
  final Dio dio;

  IdRemoteDataSource(this.dio);

  Future<Map<String, dynamic>> extractId(File image) async {
    final formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      ),
    });

    final response = await dio.post(
      ApiEndpoints.extractId,
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(minutes: 2),
      ),
    );

    return response.data["data"];
  }
}
