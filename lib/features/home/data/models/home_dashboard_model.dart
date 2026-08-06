class HomeUserModel {
  final int id;
  final String name;
  final String? avatar;

  HomeUserModel({
    required this.id,
    required this.name,
    this.avatar,
  });

  factory HomeUserModel.fromJson(Map<String, dynamic> json) {
    return HomeUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatar: json['avatar'],
    );
  }
}

class ActiveCircleModel {
  final int id;
  final String title;
  final String status;
  final double monthlyAmount;
  final int membersCount;
  final int currentTurn;
  final int totalTurns;
  final String paymentDate;

  ActiveCircleModel({
    required this.id,
    required this.title,
    required this.status,
    required this.monthlyAmount,
    required this.membersCount,
    required this.currentTurn,
    required this.totalTurns,
    required this.paymentDate,
  });

  factory ActiveCircleModel.fromJson(Map<String, dynamic> json) {
    return ActiveCircleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      status: json['status'] ?? '',
      monthlyAmount: (json['monthlyAmount'] ?? 0).toDouble(),
      membersCount: json['membersCount'] ?? 0,
      currentTurn: json['currentTurn'] ?? 0,
      totalTurns: json['totalTurns'] ?? 0,
      paymentDate: json['paymentDate'] ?? '',
    );
  }
}

class RecentActivityModel {
  final int id;
  final String type;
  final String title;
  final String description;
  final String createdAt;

  RecentActivityModel({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.createdAt,
  });

  factory RecentActivityModel.fromJson(Map<String, dynamic> json) {
    return RecentActivityModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['createdAt'] ?? '',
    );
  }
}

class HomeDashboardModel {
  final HomeUserModel user;
  final ActiveCircleModel? activeCircle;
  final List<RecentActivityModel> recentActivities;
  final List<CircleSummaryModel> recommendedCircles;

  HomeDashboardModel({
    required this.user,
    this.activeCircle,
    required this.recentActivities,
    required this.recommendedCircles,
  });

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    return HomeDashboardModel(
      user: HomeUserModel.fromJson(json['user'] ?? {}),
      activeCircle: json['activeCircle'] != null
          ? ActiveCircleModel.fromJson(json['activeCircle'])
          : null,
      recentActivities: (json['recentActivities'] as List<dynamic>? ?? [])
          .map((e) => RecentActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      recommendedCircles:
          (json['recommendedCircles'] as List<dynamic>? ?? [])
              .map(
                (e) => CircleSummaryModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );
  }
}

class CircleSummaryModel {
  final int id;
  final String title;
  final double monthlyAmount;
  final int membersCount;
  final String paymentDate;
  final String status;
  final int? currentTurn;
  final int? totalTurns;

  CircleSummaryModel({
    required this.id,
    required this.title,
    required this.monthlyAmount,
    required this.membersCount,
    required this.paymentDate,
    required this.status,
    this.currentTurn,
    this.totalTurns,
  });

  factory CircleSummaryModel.fromJson(Map<String, dynamic> json) {
    return CircleSummaryModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      monthlyAmount: (json['monthlyAmount'] ?? 0).toDouble(),
      membersCount: json['membersCount'] ?? 0,
      paymentDate: json['paymentDate'] ?? '',
      status: json['status'] ?? '',
      currentTurn: json['currentTurn'],
      totalTurns: json['totalTurns'],
    );
  }
}
