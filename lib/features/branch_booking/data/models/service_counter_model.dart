class ServiceCounterModel {
  final int id;
  final bool isOperational;
  final int serviceId;
  final String serviceName;
  final String serviceDescription;
  final double servicePrice;
  final String serviceDuration;

  ServiceCounterModel({
    required this.id,
    required this.isOperational,
    required this.serviceId,
    required this.serviceName,
    required this.serviceDescription,
    required this.servicePrice,
    required this.serviceDuration,
  });

  factory ServiceCounterModel.fromJson(Map<String, dynamic> json) {
    final service = json['service'];
    return ServiceCounterModel(
      id: json['id'],
      isOperational: json['is_operational'],
      serviceId: service['id'],
      serviceName: service['name'],
      serviceDescription: service['description'],
      servicePrice: (service['price'] as num).toDouble(),
      serviceDuration: service['duration'],
    );
  }

  Duration get duration {
    final parts = serviceDuration.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }
}
