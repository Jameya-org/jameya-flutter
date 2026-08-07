/// Nested address model returned inside [IdentityProfileModel].
class AddressModel {
  const AddressModel({this.governorate, this.city, this.streetAddress});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      governorate: json['governorate']?.toString(),
      city: json['city']?.toString(),
      streetAddress: json['streetAddress']?.toString(),
    );
  }
  final String? governorate;
  final String? city;
  final String? streetAddress;
}

/// Identity profile data returned inside [KycStatusModel].
class IdentityProfileModel {
  const IdentityProfileModel({
    this.dateOfBirth,
    this.nationalIdNumber,
    this.address,
    this.mobileNumber,
  });

  factory IdentityProfileModel.fromJson(Map<String, dynamic> json) {
    return IdentityProfileModel(
      dateOfBirth: json['dateOfBirth']?.toString(),
      nationalIdNumber: json['nationalIdNumber']?.toString(),
      address: json['address'] is Map<String, dynamic>
          ? AddressModel.fromJson(json['address'] as Map<String, dynamic>)
          : null,
      mobileNumber: json['mobileNumber']?.toString(),
    );
  }
  final String? dateOfBirth;
  final String? nationalIdNumber;
  final AddressModel? address;
  final String? mobileNumber;
}

/// A single verification document returned inside [KycStatusModel].
class KycDocumentModel {
  const KycDocumentModel({
    this.id,
    required this.docType,
    this.encryptedObjectRef,
    this.issueDate,
    this.expiryDate,
    this.status,
    this.createdAt,
  });

  factory KycDocumentModel.fromJson(Map<String, dynamic> json) {
    return KycDocumentModel(
      id: json['id']?.toString(),
      docType: json['docType']?.toString() ?? '',
      encryptedObjectRef: json['encryptedObjectRef']?.toString(),
      issueDate: json['issueDate']?.toString(),
      expiryDate: json['expiryDate']?.toString(),
      status: json['status']?.toString(),
      createdAt: json['createdAt']?.toString(),
    );
  }
  final String? id;
  final String docType;
  final String? encryptedObjectRef;
  final String? issueDate;
  final String? expiryDate;
  final String? status;
  final String? createdAt;
}

/// Eligibility result returned as [KycStatusModel.latestEligibility].
class EligibilityModel {
  const EligibilityModel({this.status, this.reason});

  factory EligibilityModel.fromJson(Map<String, dynamic> json) {
    return EligibilityModel(
      status: json['status']?.toString(),
      reason: json['reason']?.toString(),
    );
  }
  final String? status;
  final String? reason;
}

/// Maps the string returned by the backend to a typed status.
enum KycStatus { notVerified, pendingReview, verified, rejected }

KycStatus _parseKycStatus(String? raw, {bool hasDocuments = false}) {
  final statusStr = (raw ?? '').toLowerCase().trim();
  switch (statusStr) {
    case 'verified':
    case 'approved':
      return KycStatus.verified;

    case 'pending_review':
    case 'under_review':
    case 'submitted':
    case 'in_review':
      return KycStatus.pendingReview;

    case 'pending':
      // Backend returns 'pending' for newly created users who have not yet
      // submitted verification documents. If no documents have been submitted,
      // the status is 'notVerified' so the UI displays the upload form.
      return hasDocuments ? KycStatus.pendingReview : KycStatus.notVerified;

    case 'rejected':
    case 'denied':
    case 'failed':
      return KycStatus.rejected;

    case 'not_verified':
    case 'unverified':
    case 'not_started':
    case 'draft':
    case 'initial':
    case 'none':
    default:
      return KycStatus.notVerified;
  }
}

/// Full KYC status response from GET /customers/kyc-status.
class KycStatusModel {
  const KycStatusModel({
    this.legalName,
    required this.kycStatus,
    this.identityProfile,
    this.documents = const [],
    this.latestEligibility,
  });

  factory KycStatusModel.fromJson(Map<String, dynamic> json) {
    final rawStatus = (json['kycStatus'] ?? json['status'] ?? json['kyc_status'])?.toString();

    List<KycDocumentModel> docs = [];
    final rawDocs = json['documents'];
    if (rawDocs is List) {
      docs = rawDocs
          .whereType<Map<String, dynamic>>()
          .map(KycDocumentModel.fromJson)
          .toList();
    }

    IdentityProfileModel? identity;
    if (json['identityProfile'] is Map<String, dynamic>) {
      identity = IdentityProfileModel.fromJson(
        json['identityProfile'] as Map<String, dynamic>,
      );
    }

    EligibilityModel? eligibility;
    if (json['latestEligibility'] is Map<String, dynamic>) {
      eligibility = EligibilityModel.fromJson(
        json['latestEligibility'] as Map<String, dynamic>,
      );
    }

    return KycStatusModel(
      legalName: json['legalName']?.toString(),
      kycStatus: _parseKycStatus(rawStatus, hasDocuments: docs.isNotEmpty),
      identityProfile: identity,
      documents: docs,
      latestEligibility: eligibility,
    );
  }
  final String? legalName;
  final KycStatus kycStatus;
  final IdentityProfileModel? identityProfile;
  final List<KycDocumentModel> documents;
  final EligibilityModel? latestEligibility;

  /// Convenience accessor kept for the UI switch.
  KycStatus get status => kycStatus;
}
