class FeedbackModel {
  final int? id;
  final String feedback;

  FeedbackModel({this.id, required this.feedback});

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(id: json['id'], feedback: json['feedback']);
  }

  Map<String, dynamic> toJson() => {'feedback': feedback};
}
