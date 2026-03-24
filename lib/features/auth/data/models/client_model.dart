class ClientModel {
  final String nationalId;
  final String? birthDate;
  final String? profession;
  final String? gender;
  final String? address;
  final String? image;
  final String? phone;

  ClientModel({
    required this.nationalId,
    this.address,
    this.image,
    this.birthDate,
    this.gender,
    this.profession,
    this.phone,
  });

  factory ClientModel.fromJson(Map<String, dynamic> json) {
    return ClientModel(
      nationalId: json['national_id'],
      birthDate: json['birth_date'],
      profession: json['profession'],
      gender: json['gender'],
      address: json['address'],
      image: json['image'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "national_id": nationalId,
      "birth_date": birthDate,
      "profession": profession,
      "gender": gender,
      "phone": phone,
    };
  }
}
