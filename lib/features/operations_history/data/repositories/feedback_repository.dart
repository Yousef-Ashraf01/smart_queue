import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import 'package:smart_queue/features/operations_history/data/datasources/feedback_remote_data_source.dart';
import 'package:smart_queue/features/operations_history/data/models/feedback_model.dart';

class FeedbackRepository {
  final FeedbackRemoteDataSource remote;

  FeedbackRepository(this.remote);

  Future<Either<Failure, FeedbackModel>> submitFeedback({
    required int appointmentId,
    required String feedback,
  }) async {
    try {
      final result = await remote.submitFeedback(
        appointmentId: appointmentId,
        feedback: feedback,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, List<FeedbackModel>>> getFeedback(
    int appointmentId,
  ) async {
    try {
      final result = await remote.getFeedback(appointmentId);
      return Right(result);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, void>> deleteFeedback({
    required int appointmentId,
    int? feedbackId,
  }) async {
    try {
      await remote.deleteFeedback(
        appointmentId: appointmentId,
        feedbackId: feedbackId,
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
