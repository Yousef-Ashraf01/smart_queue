import 'package:dio/dio.dart';

import 'failure.dart';

Failure handleDioError(DioException e) {
  if (e.response != null && e.response!.data != null) {
    final data = e.response!.data;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('message')) {
        return ServerFailure(data['message'].toString());
      }

      List<String> errors = [];

      data.forEach((key, value) {
        if (value is List) {
          errors.addAll(value.map((v) => "$key: $v"));
        } else if (value is Map) {
          value.forEach((k, v) {
            if (v is List) {
              errors.addAll(v.map((msg) => "$key.$k: $msg"));
            } else {
              errors.add("$key.$k: $v");
            }
          });
        } else {
          errors.add("$key: $value");
        }
      });

      if (errors.isNotEmpty) {
        return ServerFailure(errors.join("\n"));
      }

      return const ServerFailure("Unknown server error");
    } else if (data is String) {
      return ServerFailure(data);
    } else {
      return const ServerFailure("Unknown server error");
    }
  } else if (e.type == DioExceptionType.connectionError) {
    return const NetworkFailure("Please check your internet connection");
  } else {
    return UnknownFailure(e.message ?? "Something went wrong");
  }
}
