import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/scan_id_card/data/datasources/id_remote_data_sources.dart';
import 'package:smart_queue/features/scan_id_card/data/models/id_extract_model.dart';

class IdRepository {
  final IdRemoteDataSource remote;

  IdRepository(this.remote);

  Future<Either<Failure, IdExtractModel>> extractId(File image) async {
    try {
      final data = await remote.extractId(image);
      return Right(IdExtractModel.fromJson(data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return const Left(
          NetworkFailure('No internet connection, please try again'),
        );
      }

      final responseData = e.response?.data;
      if (responseData != null && responseData is Map<String, dynamic>) {
        final errorMessage = responseData['error'] as String?;
        return Left(ServerFailure(_translateError(errorMessage)));
      }

      return const Left(ServerFailure('Something went wrong'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  String _translateError(String? arabicError) {
    if (arabicError == null) return 'Something went wrong, please try again';

    const Map<String, String> _errorMap = {
      'الصورة مش واضحة، صور تاني':
          'Image is not clear, please take another photo',
    };

    return _errorMap[arabicError] ?? 'Something went wrong, please try again';
  }
}
