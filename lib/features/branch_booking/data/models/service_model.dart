class ServiceModel {
  final int id;
  final String name;
  final double price;
  final Duration duration;

  ServiceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.duration,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      duration: _parseDuration(json['duration']),
    );
  }

  static Duration _parseDuration(String time) {
    final parts = time.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }
}
