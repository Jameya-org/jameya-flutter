class ProfileModel {
  final String id;
  final String legalName;
  final String email;
  final String mobileNumber;
  final String status;
  final String locale;
  final String createdAt;
  // Local-only fields (not returned by /customers/profile but editable locally)
  final String? kycStatus;
  final String? nationalId;
  final String? birthDate;
  final String? governorate;
  final String? city;
  final String? streetAddress;

  ProfileModel({
    this.id = '',
    required this.legalName,
    required this.email,
    this.mobileNumber = '',
    this.status = '',
    this.locale = '',
    this.createdAt = '',
    this.kycStatus,
    this.nationalId,
    this.birthDate,
    this.governorate,
    this.city,
    this.streetAddress,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      legalName: json['legalName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      status: json['status'] ?? '',
      locale: json['locale'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }

  ProfileModel copyWith({
    String? legalName,
    String? mobileNumber,
    String? nationalId,
    String? birthDate,
    String? governorate,
    String? city,
    String? streetAddress,
  }) {
    return ProfileModel(
      id: id,
      legalName: legalName ?? this.legalName,
      email: email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status,
      locale: locale,
      createdAt: createdAt,
      kycStatus: kycStatus,
      nationalId: nationalId ?? this.nationalId,
      birthDate: birthDate ?? this.birthDate,
      governorate: governorate ?? this.governorate,
      city: city ?? this.city,
      streetAddress: streetAddress ?? this.streetAddress,
    );
  }
}
