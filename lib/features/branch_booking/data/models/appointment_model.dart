class AppointmentModel {
  final int? id;
  final int appointmentRequest;
  final String phone;
  final String address;
  final bool wantReminder;
  final String additionalInfo;
  final bool paid;
  final double amountToPay;

  AppointmentModel({
    this.id,
    required this.appointmentRequest,
    required this.phone,
    required this.address,
    required this.wantReminder,
    required this.additionalInfo,
    required this.paid,
    required this.amountToPay,
  });

  Map<String, dynamic> toJson() {
    return {
      "appointment_request": appointmentRequest,
      "phone": phone,
      "address": address,
      "want_reminder": wantReminder,
      "additional_info": additionalInfo,
      "paid": paid,
      "amount_to_pay": amountToPay,
    };
  }

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      appointmentRequest: json['appointment_request'],
      phone: json['phone'],
      address: json['address'],
      wantReminder: json['want_reminder'],
      additionalInfo: json['additional_info'],
      paid: json['paid'],
      amountToPay: (json['amount_to_pay'] as num).toDouble(),
    );
  }
}
