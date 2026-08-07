/// Customer profile returned by GET /customers/profile.
///
/// Only contains the fields the backend actually returns. Identity-specific
/// fields (nationalIdNumber, dateOfBirth, address) live in
/// [KycStatusModel.identityProfile] and are managed by [KycProvider].
class ProfileModel {
  final String id;
  final String legalName;
  final String email;
  final String mobileNumber;
  final String status;
  final String locale;
  final String createdAt;

  const ProfileModel({
    this.id = '',
    required this.legalName,
    required this.email,
    this.mobileNumber = '',
    this.status = '',
    this.locale = '',
    this.createdAt = '',
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id']?.toString() ?? '',
      legalName: json['legalName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      mobileNumber: json['mobileNumber']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      locale: json['locale']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  ProfileModel copyWith({
    String? legalName,
    String? mobileNumber,
    String? status,
    String? locale,
  }) {
    return ProfileModel(
      id: id,
      legalName: legalName ?? this.legalName,
      email: email,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      status: status ?? this.status,
      locale: locale ?? this.locale,
      createdAt: createdAt,
    );
  }
}
