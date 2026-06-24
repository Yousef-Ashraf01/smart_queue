class ChatbotMessageModel {
  final String? message;
  final bool isUser;
  final List<Map<String, dynamic>>? buttons;
  final String? responseType;

  ChatbotMessageModel({
    this.message,
    required this.isUser,
    this.buttons,
    this.responseType,
  });

  factory ChatbotMessageModel.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>>? parsedButtons;
    
    if (json['buttons'] != null) {
      if (json['buttons'] is List) {
        parsedButtons = (json['buttons'] as List)
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
    }

    return ChatbotMessageModel(
      message: json['message'],
      isUser: json['isUser'] ?? false,
      buttons: parsedButtons,
      responseType: json['responseType'],
    );
  }
}
