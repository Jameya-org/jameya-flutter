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

  factory KycStatusModel.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status'] ?? '').toString().toLowerCase();
    KycStatus status;
    switch (statusStr) {
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

    return KycStatusModel(
      status: status,
      fullName: json['fullName'],
      idNumber: json['idNumber'],
      verifiedAt: json['verifiedAt'],
      nationalIdUploaded: json['nationalIdUploaded'] ?? false,
      incomeProofUploaded: json['incomeProofUploaded'] ?? false,
      submittedAt: json['submittedAt'],
    );
  }
}
