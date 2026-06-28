class PaymentIntentModel {
  final String clientSecret;
  final String? paymentIntentId;

  PaymentIntentModel({
    required this.clientSecret,
    this.paymentIntentId,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      clientSecret: json['client_secret'] ?? json['clientSecret'] ?? '',
      paymentIntentId: json['payment_intent_id'] ?? json['id']?.toString(),
    );
  }
}
