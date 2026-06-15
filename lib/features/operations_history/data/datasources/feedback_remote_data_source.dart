import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';
import 'package:smart_queue/features/operations_history/data/models/feedback_model.dart';

class FeedbackRemoteDataSource {
  final Dio dio;

  FeedbackRemoteDataSource(this.dio);

  Future<FeedbackModel> submitFeedback({
    required int appointmentId,
    required String feedback,
  }) async {
    final response = await dio.post(
      ApiEndpoints.feedback(appointmentId),
      data: {'feedback': feedback},
    );
    return FeedbackModel.fromJson(response.data);
  }

  Future<List<FeedbackModel>> getFeedback(int appointmentId) async {
    try {
      final response = await dio.get(
        '${ApiEndpoints.appointments}$appointmentId/feedback/',
      );
      print('FEEDBACK RESPONSE: ${response.data}');

      final List data =
          response.data is List
              ? response.data
              : response.data['results'] ?? [];

      return data
          .map((e) => FeedbackModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteFeedback({
    required int appointmentId,
    int? feedbackId,
  }) async {
    if (feedbackId != null) {
      await dio.delete(
        '${ApiEndpoints.appointments}$appointmentId/feedback/$feedbackId/',
      );
    } else {
      await dio.delete('${ApiEndpoints.appointments}$appointmentId/feedback/');
    }
  }
}
