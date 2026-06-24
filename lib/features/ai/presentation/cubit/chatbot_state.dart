import 'package:equatable/equatable.dart';
import '../../data/models/chatbot_message_model.dart';

abstract class ChatbotState extends Equatable {
  final List<ChatbotMessageModel> messages;
  final String? activeInputMode;

  const ChatbotState({
    this.messages = const [],
    this.activeInputMode,
  });

  @override
  List<Object?> get props => [messages, activeInputMode];
}

class ChatbotInitial extends ChatbotState {
  const ChatbotInitial({super.messages, super.activeInputMode});
}

class ChatbotLoading extends ChatbotState {
  const ChatbotLoading({super.messages, super.activeInputMode});
}

class ChatbotSuccess extends ChatbotState {
  const ChatbotSuccess({super.messages, super.activeInputMode});
}

class ChatbotFailure extends ChatbotState {
  final String error;

  const ChatbotFailure(this.error, {super.messages, super.activeInputMode});

  @override
  List<Object?> get props => [messages, activeInputMode, error];
}
