enum KycStatus { notVerified, pendingReview, verified, rejected }

class KycStatusModel {
  final KycStatus status;
  final String? fullName;
  final String? idNumber;
  final String? verifiedAt;
  final bool nationalIdUploaded;
  final bool incomeProofUploaded;
  final String? submittedAt;

  KycStatusModel({
    required this.status,
    this.fullName,
    this.idNumber,
    this.verifiedAt,
    required this.nationalIdUploaded,
    required this.incomeProofUploaded,
    this.submittedAt,
  });

  /// Parses the KYC status response.
  ///
  /// Handles **both** response shapes to guard against backend variations:
  ///
  /// **Shape A (flat):**
  /// ```json
  /// { "status": "verified", "fullName": "...", "nationalIdUploaded": true }
  /// ```
  ///
  /// **Shape B (nested — as documented in jameya-api.md):**
  /// ```json
  /// {
  ///   "kycStatus": "VERIFIED",
  ///   "legalName": "...",
  ///   "identityProfile": { "nationalId": "..." },
  ///   "documents": [{ "docType": "NATIONAL_ID", "status": "APPROVED" }],
  ///   "latestEligibility": { ... }
  /// }
  /// ```
  factory KycStatusModel.fromJson(Map<String, dynamic> json) {
    // ── Status resolution ─────────────────────────────────────────────────
    // Try documented field `kycStatus` first, then fallback to `status`.
    final rawStatus =
        (json['kycStatus'] ?? json['status'] ?? '').toString().toLowerCase();

    KycStatus status;
    switch (rawStatus) {
      case 'verified':
      case 'approved':
        status = KycStatus.verified;
        break;
      case 'pending':
      case 'pending_review':
      case 'under_review':
        status = KycStatus.pendingReview;
        break;
      case 'rejected':
        status = KycStatus.rejected;
        break;
      default:
        status = KycStatus.notVerified;
    }

    // ── Name resolution ───────────────────────────────────────────────────
    // Try flat `fullName`, then documented `legalName`.
    final fullName =
        json['fullName'] ?? json['legalName'];

    // ── ID number resolution ──────────────────────────────────────────────
    // Try flat `idNumber`, then nested `identityProfile.nationalId`.
    String? idNumber = json['idNumber'];
    if (idNumber == null) {
      final identityProfile = json['identityProfile'];
      if (identityProfile is Map) {
        idNumber = identityProfile['nationalId']?.toString();
      }
    }

    // ── Document upload status resolution ─────────────────────────────────
    // Try flat booleans first, then infer from nested `documents` array.
    bool nationalIdUploaded = json['nationalIdUploaded'] ?? false;
    bool incomeProofUploaded = json['incomeProofUploaded'] ?? false;

    final documents = json['documents'];
    if (documents is List && documents.isNotEmpty) {
      for (final doc in documents) {
        if (doc is Map) {
          final docType = doc['docType']?.toString();
          if (docType == 'NATIONAL_ID') nationalIdUploaded = true;
          if (docType == 'PROOF_OF_INCOME') incomeProofUploaded = true;
        }
      }
    }

    return KycStatusModel(
      status: status,
      fullName: fullName?.toString(),
      idNumber: idNumber,
      verifiedAt: json['verifiedAt']?.toString(),
      nationalIdUploaded: nationalIdUploaded,
      incomeProofUploaded: incomeProofUploaded,
      submittedAt: json['submittedAt']?.toString(),
    );
  }
}

