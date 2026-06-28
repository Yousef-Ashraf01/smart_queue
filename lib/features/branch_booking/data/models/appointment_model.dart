class AppointmentModel {
  final String date;
  final String startTime;
  final String counterId;
  final bool wantReminder;
  final String additionalInfo;
  final bool paid;
  final double amountToPay;
  final String paymentMethod; // "CASH" or "ONLINE"

  AppointmentModel({
    required this.date,
    required this.startTime,
    required this.counterId,
    required this.wantReminder,
    required this.additionalInfo,
    required this.paid,
    required this.amountToPay,
    this.paymentMethod = 'CASH',
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "start_time": startTime,
      "counter_id": counterId,
      "want_reminder": wantReminder,
      "additional_info": additionalInfo,
      "paid": paid,
      "amount_to_pay": amountToPay,
      "payment_method": paymentMethod,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      date: json['date'],
      startTime: json['start_time'],
      counterId: json['counter_id'].toString(),
      wantReminder: json['want_reminder'],
      additionalInfo: json['additional_info'],
      paid: json['paid'],
      amountToPay: (json['amount_to_pay'] as num).toDouble(),
      paymentMethod: json['payment_method'] ?? 'CASH',
    );
  }
}

