class ServiceModel {
  final int id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String duration;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.duration,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      currency: json['currency'],
      duration: json['duration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'duration': duration,
    };
  }
}
