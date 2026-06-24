import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smart_queue/core/errors/error_handler.dart';
import 'package:smart_queue/core/errors/failure.dart';
import '../datasources/chatbot_remote_data_source.dart';
import '../models/chatbot_message_model.dart';

class ChatbotRepository {
  final ChatbotRemoteDataSource remoteDataSource;

  ChatbotRepository(this.remoteDataSource);

  Future<Either<Failure, ChatbotMessageModel>> sendAction(Map<String, dynamic> payload) async {
    try {
      final response = await remoteDataSource.sendAction(payload);
      return Right(response);
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
