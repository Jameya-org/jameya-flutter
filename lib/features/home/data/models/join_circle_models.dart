// ─────────────────────────────────────────────────────────────
// POST /customer/circles/{id}/join-intent
// Success 200
// ─────────────────────────────────────────────────────────────

class JoinIntentResponseModel {
  final bool canJoin;
  final String circleId;
  final bool eligible;
  final bool capacityAvailable;
  final bool hasPendingReservation;
  final bool requiresKyc;
  final bool requiresDocuments;
  final String message;

  JoinIntentResponseModel({
    required this.canJoin,
    required this.circleId,
    required this.eligible,
    required this.capacityAvailable,
    required this.hasPendingReservation,
    required this.requiresKyc,
    required this.requiresDocuments,
    required this.message,
  });

  factory JoinIntentResponseModel.fromJson(Map<String, dynamic> json) {
    return JoinIntentResponseModel(
      canJoin: json['canJoin'] ?? false,
      circleId: json['circleId']?.toString() ?? '',
      eligible: json['eligible'] ?? false,
      capacityAvailable: json['capacityAvailable'] ?? false,
      hasPendingReservation: json['hasPendingReservation'] ?? false,
      requiresKyc: json['requiresKyc'] ?? false,
      requiresDocuments: json['requiresDocuments'] ?? false,
      message: json['message']?.toString() ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POST /customer/circles/{id}/join-intent
// Validation Failure 422
// ─────────────────────────────────────────────────────────────

class JoinIntentFailureModel {
  final String reason;
  final List<String> missingSteps;

  JoinIntentFailureModel({
    required this.reason,
    required this.missingSteps,
  });

  factory JoinIntentFailureModel.fromJson(Map<String, dynamic> json) {
    return JoinIntentFailureModel(
      reason: json['reason']?.toString() ?? 'eligibility_incomplete',
      missingSteps: (json['missingSteps'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POST /customer/circles/{id}/join
// Success 201 — embedded contract
// ─────────────────────────────────────────────────────────────

class EmbeddedContractModel {
  final String id;
  final int version;
  final String downloadUrl;

  EmbeddedContractModel({
    required this.id,
    required this.version,
    required this.downloadUrl,
  });

  factory EmbeddedContractModel.fromJson(Map<String, dynamic> json) {
    return EmbeddedContractModel(
      id: json['id']?.toString() ?? '',
      version: (json['version'] as num?)?.toInt() ?? 1,
      downloadUrl: json['downloadUrl']?.toString() ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POST /customer/circles/{id}/join
// Success 201 — top-level join response
// ─────────────────────────────────────────────────────────────

class JoinReservationModel {
  final String membershipId;
  final String reservationId;
  final String reservationExpiresAt;
  final String status;
  final EmbeddedContractModel contract;

  JoinReservationModel({
    required this.membershipId,
    required this.reservationId,
    required this.reservationExpiresAt,
    required this.status,
    required this.contract,
  });

  factory JoinReservationModel.fromJson(Map<String, dynamic> json) {
    return JoinReservationModel(
      membershipId: json['membershipId']?.toString() ?? '',
      reservationId: json['reservationId']?.toString() ?? '',
      reservationExpiresAt: json['reservationExpiresAt']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      contract: EmbeddedContractModel.fromJson(
        (json['contract'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POST /customer/join/{membershipId}/contract/accept
// Success 200
// ─────────────────────────────────────────────────────────────

class AcceptContractResponseModel {
  final bool success;
  final String membershipId;
  final bool otpSent;
  final int expiresIn;
  final String message;

  AcceptContractResponseModel({
    required this.success,
    required this.membershipId,
    required this.otpSent,
    required this.expiresIn,
    required this.message,
  });

  factory AcceptContractResponseModel.fromJson(Map<String, dynamic> json) {
    return AcceptContractResponseModel(
      success: json['success'] ?? false,
      membershipId: json['membershipId']?.toString() ?? '',
      otpSent: json['otpSent'] ?? false,
      expiresIn: (json['expiresIn'] as num?)?.toInt() ?? 60,
      message: json['message']?.toString() ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────
// POST /customer/join/{membershipId}/contract/verify-otp
// Success 200
// ─────────────────────────────────────────────────────────────

class VerifyOtpResponseModel {
  final bool success;
  final String membershipId;
  final String status;
  final String joinedAt;
  final String message;

  VerifyOtpResponseModel({
    required this.success,
    required this.membershipId,
    required this.status,
    required this.joinedAt,
    required this.message,
  });

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyOtpResponseModel(
      success: json['success'] ?? false,
      membershipId: json['membershipId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      joinedAt: json['joinedAt']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────
// GET /customer/contracts/{membershipId}
// ─────────────────────────────────────────────────────────────

class ContractModel {
  final String id;
  final String membershipId;
  final String status;
  final String? signedAt;
  final int version;
  final String downloadUrl;

  ContractModel({
    required this.id,
    required this.membershipId,
    required this.status,
    this.signedAt,
    required this.version,
    required this.downloadUrl,
  });

  factory ContractModel.fromJson(Map<String, dynamic> json) {
    return ContractModel(
      id: json['id']?.toString() ?? '',
      membershipId: json['membershipId']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      signedAt: json['signedAt']?.toString(),
      version: (json['version'] as num?)?.toInt() ?? 1,
      downloadUrl: json['downloadUrl']?.toString() ?? '',
    );
  }
}
