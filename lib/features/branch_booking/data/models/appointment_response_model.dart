import 'package:smart_queue/features/branch_booking/data/models/service_model.dart';

class AppointmentResponseModel {
  final int id;
  final String date;
  final String startTime;
  final String endTime;
  final bool wantReminder;
  final String additionalInfo;
  final bool paid;
  final double? amountToPay;
  final CounterModel counter;

  AppointmentResponseModel({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.wantReminder,
    required this.additionalInfo,
    required this.paid,
    required this.amountToPay,
    required this.counter,
  });

  factory AppointmentResponseModel.fromJson(Map<String, dynamic> json) {
    return AppointmentResponseModel(
      id: json['id'],
      date: json['date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      wantReminder: json['want_reminder'],
      additionalInfo: json['additional_info'] ?? "",
      paid: json['paid'],
      amountToPay: (json['amount_to_pay']) ?? 0,
      counter: CounterModel.fromJson(json['counter']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'want_reminder': wantReminder,
      'additional_info': additionalInfo,
      'paid': paid,
      'amount_to_pay': amountToPay,
      'counter_id': counter.id,
    };
  }

  AppointmentResponseModel copyWith({
    int? id,
    String? date,
    String? startTime,
    String? endTime,
    bool? wantReminder,
    String? additionalInfo,
    bool? paid,
    double? amountToPay,
    CounterModel? counter,
  }) {
    return AppointmentResponseModel(
      id: id ?? this.id,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      wantReminder: wantReminder ?? this.wantReminder,
      additionalInfo: additionalInfo ?? this.additionalInfo,
      paid: paid ?? this.paid,
      amountToPay: amountToPay ?? this.amountToPay,
      counter: counter ?? this.counter,
    );
  }
}

class CounterModel {
  final int id;
  final String name;
  final bool isOperational;
  final ServiceModel service;

  CounterModel({
    required this.id,
    required this.name,
    required this.isOperational,
    required this.service,
  });

  factory CounterModel.fromJson(Map<String, dynamic> json) {
    return CounterModel(
      id: json['id'],
      name: json['name'],
      isOperational: json['is_operational'],
      service: ServiceModel.fromJson(json['service']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_operational': isOperational,
      'service': service.toJson(),
    };
  }
}
