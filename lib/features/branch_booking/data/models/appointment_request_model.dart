// import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';
//
// class AppointmentRequestModel {
//   final int? id;
//   final String date;
//   final String startTime;
//   final String endTime;
//   final ServiceModel service;
//   final StaffMemberModel? staffMember;
//   final String paymentType;
//   final int rescheduleAttempts;
//   final String? idRequest;
//   final List<ServiceModel>? services;
//
//   AppointmentRequestModel({
//     this.id,
//     required this.date,
//     required this.startTime,
//     required this.endTime,
//     required this.service,
//     this.staffMember,
//     required this.paymentType,
//     required this.rescheduleAttempts,
//     this.idRequest,
//     this.services,
//   });
//
//   factory AppointmentRequestModel.fromJson(Map<String, dynamic> json) {
//     return AppointmentRequestModel(
//       id: json['id'],
//       date: json['date'],
//       startTime: json['start_time'],
//       endTime: json['end_time'],
//       service: ServiceModel.fromJson(json['service']),
//       staffMember:
//           json['staff_member'] != null
//               ? StaffMemberModel.fromJson(json['staff_member'])
//               : null,
//       paymentType: json['payment_type'],
//       rescheduleAttempts: json['reschedule_attempts'],
//       idRequest: json['id_request'],
//     );
//   }
//
//   AppointmentRequestModel copyWith({
//     int? id,
//     String? date,
//     String? startTime,
//     String? endTime,
//     ServiceModel? service,
//     StaffMemberModel? staffMember,
//     String? paymentType,
//     int? rescheduleAttempts,
//     String? idRequest,
//   }) {
//     return AppointmentRequestModel(
//       id: id ?? this.id,
//       date: date ?? this.date,
//       startTime: startTime ?? this.startTime,
//       endTime: endTime ?? this.endTime,
//       service: service ?? this.service,
//       staffMember: staffMember ?? this.staffMember,
//       paymentType: paymentType ?? this.paymentType,
//       rescheduleAttempts: rescheduleAttempts ?? this.rescheduleAttempts,
//       idRequest: idRequest ?? this.idRequest,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'date': date,
//       'start_time': startTime,
//       'end_time': endTime,
//       'service': service.toJson(),
//       'staff_member': staffMember?.toJson(),
//       'payment_type': paymentType,
//       'reschedule_attempts': rescheduleAttempts,
//       'id_request': idRequest,
//     };
//   }
// }
//
// class StaffMemberModel {
//   final int id;
//   final String name;
//   final String email;
//
//   StaffMemberModel({required this.id, required this.name, required this.email});
//
//   factory StaffMemberModel.fromJson(Map<String, dynamic> json) {
//     return StaffMemberModel(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {'id': id, 'name': name, 'email': email};
//   }
// }
