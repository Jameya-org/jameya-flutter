// ─────────────────────────────────────────────────────────────
// Endpoint 1: GET /customers/profile
// ─────────────────────────────────────────────────────────────

class HomeUserModel {
  final String id;
  final String legalName;
  final String email;
  final String mobileNumber;
  final String status;
  final String locale;
  final String createdAt;

  HomeUserModel({
    required this.id,
    required this.legalName,
    required this.email,
    required this.mobileNumber,
    required this.status,
    required this.locale,
    required this.createdAt,
  });

  factory HomeUserModel.fromJson(Map<String, dynamic> json) {
    return HomeUserModel(
      id: json['id']?.toString() ?? '',
      legalName: json['legalName'] ?? '',
      email: json['email'] ?? '',
      mobileNumber: json['mobileNumber'] ?? '',
      status: json['status'] ?? '',
      locale: json['locale'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Endpoint 4: GET /customer/home
// ─────────────────────────────────────────────────────────────

class HomeEligibilityModel {
  final bool eligible;
  final String reason;
  final List<String> missingSteps;

  HomeEligibilityModel({
    required this.eligible,
    required this.reason,
    required this.missingSteps,
  });

  factory HomeEligibilityModel.fromJson(Map<String, dynamic> json) {
    return HomeEligibilityModel(
      eligible: json['eligible'] ?? false,
      reason: json['reason'] ?? '',
      missingSteps: (json['missingSteps'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Endpoint 2: GET /customer/circles
// Endpoint 5: GET /customer/my-circles
// ─────────────────────────────────────────────────────────────

class CircleSummaryModel {
  final String id;
  final String title;
  final String amount;
  final String contributionAmount;
  final int durationMonths;
  final String cycleFrequency;
  final int memberCapacity;
  final int currentMembersCount;
  final String startDate;
  final String status;

  CircleSummaryModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.contributionAmount,
    required this.durationMonths,
    required this.cycleFrequency,
    required this.memberCapacity,
    required this.currentMembersCount,
    required this.startDate,
    required this.status,
  });

  factory CircleSummaryModel.fromJson(Map<String, dynamic> json) {
    return CircleSummaryModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      contributionAmount: json['contributionAmount']?.toString() ?? '0',
      durationMonths: _parseInt(json['durationMonths']),
      cycleFrequency: json['cycleFrequency'] ?? '',
      memberCapacity: _parseInt(json['memberCapacity']),
      currentMembersCount: _parseInt(json['currentMembersCount']),
      startDate: json['startDate']?.toString() ?? '',
      status: json['status'] ?? '',
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

// ─────────────────────────────────────────────────────────────
// Pagination metadata
// ─────────────────────────────────────────────────────────────

class PaginationMeta {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  PaginationMeta({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      totalPages: json['totalPages'] ?? 1,
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Endpoint 3: GET /customer/circles/{id}
// ─────────────────────────────────────────────────────────────

class MembershipModel {
  final String displayName;
  final int payoutPosition;
  final String currentCyclePaymentStatus;
  final String joinedAt;
  final bool isYou;

  MembershipModel({
    required this.displayName,
    required this.payoutPosition,
    required this.currentCyclePaymentStatus,
    required this.joinedAt,
    required this.isYou,
  });

  factory MembershipModel.fromJson(Map<String, dynamic> json) {
    return MembershipModel(
      displayName: json['displayName'] ?? '',
      payoutPosition: json['payoutPosition'] ?? 0,
      currentCyclePaymentStatus: json['currentCyclePaymentStatus'] ?? '',
      joinedAt: json['joinedAt'] ?? '',
      isYou: json['isYou'] ?? false,
    );
  }
}

class CircleDetailModel {
  final String id;
  final String title;
  final String amount;
  final String contributionAmount;
  final int durationMonths;
  final String cycleFrequency;
  final int memberCapacity;
  final int currentMembersCount;
  final String startDate;
  final String? endDate;
  final String status;
  final String? feePolicyId;
  final List<MembershipModel> memberships;

  CircleDetailModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.contributionAmount,
    required this.durationMonths,
    required this.cycleFrequency,
    required this.memberCapacity,
    required this.currentMembersCount,
    required this.startDate,
    this.endDate,
    required this.status,
    this.feePolicyId,
    required this.memberships,
  });

  factory CircleDetailModel.fromJson(Map<String, dynamic> json) {
    return CircleDetailModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      contributionAmount: json['contributionAmount']?.toString() ?? '0',
      durationMonths: CircleSummaryModel._parseInt(json['durationMonths']),
      cycleFrequency: json['cycleFrequency'] ?? '',
      memberCapacity: CircleSummaryModel._parseInt(json['memberCapacity']),
      currentMembersCount:
          CircleSummaryModel._parseInt(json['currentMembersCount']),
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString(),
      status: json['status'] ?? '',
      feePolicyId: json['feePolicyId']?.toString(),
      memberships: (json['memberships'] as List<dynamic>? ?? [])
          .map((e) => MembershipModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Endpoint 6: GET /customer/circles/{id}/positions
// ─────────────────────────────────────────────────────────────

class FeePreviewModel {
  final String gross;
  final String feeAmount;
  final String net;
  final String feePercentage;

  FeePreviewModel({
    required this.gross,
    required this.feeAmount,
    required this.net,
    required this.feePercentage,
  });

  factory FeePreviewModel.fromJson(Map<String, dynamic> json) {
    return FeePreviewModel(
      gross: json['gross']?.toString() ?? '0',
      feeAmount: json['feeAmount']?.toString() ?? '0',
      net: json['net']?.toString() ?? '0',
      feePercentage: json['feePercentage']?.toString() ?? '0',
    );
  }
}

class PositionModel {
  final int position;
  final bool isAvailable;
  final FeePreviewModel feePreview;

  PositionModel({
    required this.position,
    required this.isAvailable,
    required this.feePreview,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) {
    return PositionModel(
      position: CircleSummaryModel._parseInt(json['position']),
      isAvailable: json['isAvailable'] ?? false,
      feePreview: FeePreviewModel.fromJson(
        (json['feePreview'] as Map<String, dynamic>?) ?? {},
      ),
    );
  }
}

class CirclePositionsModel {
  final String circleId;
  final int durationMonths;
  final List<PositionModel> positions;

  CirclePositionsModel({
    required this.circleId,
    required this.durationMonths,
    required this.positions,
  });

  factory CirclePositionsModel.fromJson(Map<String, dynamic> json) {
    return CirclePositionsModel(
      circleId: json['circleId']?.toString() ?? '',
      durationMonths: CircleSummaryModel._parseInt(json['durationMonths']),
      positions: (json['positions'] as List<dynamic>? ?? [])
          .map((e) => PositionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
