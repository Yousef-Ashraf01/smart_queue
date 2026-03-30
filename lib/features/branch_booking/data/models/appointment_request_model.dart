class AppointmentRequestModel {
  final String date;
  final String startTime;
  final String endTime;
  final int service;
  final int? staffMember;
  final String? paymentType;
  final int? rescheduleAttempts;
  final String? idRequest;

  AppointmentRequestModel({
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.service,
    this.staffMember,
    this.paymentType,
    this.rescheduleAttempts,
    this.idRequest,
  });

  Map<String, dynamic> toJson() {
    return {
      "date": date,
      "start_time": startTime,
      "end_time": endTime,
      "service": service,
      "staff_member": staffMember,
      "payment_type": paymentType,
      "reschedule_attempts": rescheduleAttempts,
      "id_request": idRequest,
    };
  }
}
