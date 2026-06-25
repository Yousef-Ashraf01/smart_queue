import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_queue/core/networking/api_endpoints.dart';

import '../models/chatbot_message_model.dart';

class ChatbotRemoteDataSource {
  final Dio dio;

  ChatbotRemoteDataSource(this.dio);

  Future<ChatbotMessageModel> sendAction(Map<String, dynamic> payload) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': ApiEndpoints.aiChatbotToken,
      'Accept': 'application/json',
    };

    try {
      final response = await dio.post(
        ApiEndpoints.aiChatbot,
        data: payload,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      // Handle n8n array responses: if the response is a List, grab the first element
      var responseData = response.data;
      if (responseData is String) {
        // Just in case Content-Type wasn't set correctly by n8n
        try {
          responseData = jsonDecode(responseData);
        } catch (_) {}
      }

      if (responseData is List) {
        if (responseData.isNotEmpty) {
          responseData = responseData.first;
        } else {
          responseData = {};
        }
      }

      return ChatbotMessageModel.fromJson(responseData as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
