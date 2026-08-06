class ProfileModel {
  final String name;
  final String email;
  final String? phone;
  final String? avatarUrl;
  final String? kycStatus;
  final String? address;
  final String? birthDate;
  final String? nationalId;
  final String? governorate;
  final String? city;
  final String? streetAddress;

  ProfileModel({
    required this.name,
    required this.email,
    this.phone,
    this.avatarUrl,
    this.kycStatus,
    this.address,
    this.birthDate,
    this.nationalId,
    this.governorate,
    this.city,
    this.streetAddress,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      avatarUrl: json['avatarUrl'],
      kycStatus: json['kycStatus'],
      address: json['address'],
      birthDate: json['birthDate'],
    );
  }

  ProfileModel copyWith({
    String? name,
    String? phone,
    String? address,
    String? birthDate,
    String? nationalId,
    String? governorate,
    String? city,
    String? streetAddress,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      email: email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl,
      kycStatus: kycStatus,
      address: address ?? this.address,
      birthDate: birthDate ?? this.birthDate,
      nationalId: nationalId ?? this.nationalId,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
    );
  }
}
