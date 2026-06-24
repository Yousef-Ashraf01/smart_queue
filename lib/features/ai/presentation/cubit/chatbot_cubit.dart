import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_cubit.dart';
import 'package:smart_queue/features/personal_info/presentation/cubit/personal_info_state.dart';
import '../../data/models/chatbot_message_model.dart';
import '../../data/repositories/chatbot_repository.dart';
import 'chatbot_state.dart';

class ChatbotCubit extends Cubit<ChatbotState> {
  final ChatbotRepository repository;
  final PersonalInfoCubit personalInfoCubit;

  ChatbotCubit(this.repository, this.personalInfoCubit) : super(const ChatbotInitial());

  void initializeChat() {
    sendAction(const {"action": "START"}, userLabel: null);
  }

  Future<void> sendAction(Map<String, dynamic> payload, {String? userLabel}) async {
    final currentMessages = List<ChatbotMessageModel>.from(state.messages);

    // If the user clicked a button with a label, show it in the chat
    if (userLabel != null && userLabel.isNotEmpty) {
      currentMessages.add(ChatbotMessageModel(message: userLabel, isUser: true));
    }

    emit(ChatbotLoading(messages: currentMessages, activeInputMode: null));

    // Append userPhone to every outgoing payload
    String userPhone = "";
    final personalState = personalInfoCubit.state;
    if (personalState is PersonalInfoLoaded) {
      userPhone = personalState.profile.client.phone ?? "";
    }
    
    // Preserve the full button payload, plus add userPhone
    final fullPayload = Map<String, dynamic>.from(payload);
    fullPayload['userPhone'] = userPhone;

    final result = await repository.sendAction(fullPayload);

    if (isClosed) return;

    result.fold(
      (failure) {
        emit(ChatbotFailure(failure.message, messages: currentMessages, activeInputMode: null));
      },
      (botMessage) {
        currentMessages.add(botMessage);
        
        String? newActiveInputMode;
        if (botMessage.responseType != null && botMessage.responseType!.startsWith('INPUT_')) {
          newActiveInputMode = botMessage.responseType;
        }

        emit(ChatbotSuccess(messages: currentMessages, activeInputMode: newActiveInputMode));
      },
    );
  }
}
