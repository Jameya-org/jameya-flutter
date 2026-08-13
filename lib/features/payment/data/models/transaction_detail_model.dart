enum TransactionStatus { paid, pending, failed, due, late, received }

class TransactionDetailModel {
  final String? id;
  final String? circleId;
  final String circleName;
  final String installmentNumber;
  final String amount;
  final String dueDate;
  final String cardBrand;
  final String cardLast4;
  final String? referenceNumber;
  final String? paidAt;
  final String? receiptUrl;
  final TransactionStatus status;

  const TransactionDetailModel({
    this.id,
    this.circleId,
    required this.circleName,
    required this.installmentNumber,
    required this.amount,
    required this.dueDate,
    required this.cardBrand,
    required this.cardLast4,
    this.referenceNumber,
    this.paidAt,
    this.receiptUrl,
    required this.status,
  });

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) {
    // ── Parse Status ───────────────────────────────────────────
    final rawStatus = (json['status'] ?? '').toString().toLowerCase();
    TransactionStatus parsedStatus;
    if (rawStatus == 'paid' || rawStatus == 'completed' || rawStatus == 'success') {
      parsedStatus = TransactionStatus.paid;
    } else if (rawStatus == 'received' || rawStatus == 'payout_disbursed') {
      parsedStatus = TransactionStatus.received;
    } else if (rawStatus == 'late' || rawStatus == 'overdue') {
      parsedStatus = TransactionStatus.late;
    } else if (rawStatus == 'due' || rawStatus == 'upcoming') {
      parsedStatus = TransactionStatus.due;
    } else if (rawStatus == 'failed' || rawStatus == 'rejected') {
      parsedStatus = TransactionStatus.failed;
    } else {
      parsedStatus = TransactionStatus.pending;
    }

    // ── Parse Circle Name ──────────────────────────────────────
    String circleNameStr = 'جمعية';
    if (json['circleName'] != null) {
      circleNameStr = json['circleName'].toString();
    } else if (json['circle'] is Map && json['circle']['name'] != null) {
      circleNameStr = json['circle']['name'].toString();
    } else if (json['circleTitle'] != null) {
      circleNameStr = json['circleTitle'].toString();
    }

    // ── Parse Payment Method Card Info ──────────────
    String brand = json['cardBrand']?.toString() ?? 'Credit card';
    String last4 = json['cardLast4']?.toString() ?? '****';
    if (json['paymentMethod'] is Map) {
      final pm = json['paymentMethod'] as Map;
      if (pm['brand'] != null) brand = pm['brand'].toString();
      if (pm['last4'] != null) last4 = pm['last4'].toString();
    }

    // ── Parse Amount ───────────────────────────────────────────
    final rawAmount = json['amount'] ?? json['dueAmount'] ?? json['totalAmount'] ?? '0';
    final formattedAmount = rawAmount.toString().contains('ج.م')
        ? rawAmount.toString()
        : '$rawAmount ج.م';

    return TransactionDetailModel(
      id: json['id']?.toString() ?? json['installmentId']?.toString() ?? json['_id']?.toString(),
      circleId: json['circleId']?.toString(),
      circleName: circleNameStr,
      installmentNumber: (json['installmentNumber'] ?? json['installmentNo'] ?? json['number'] ?? '1').toString(),
      amount: formattedAmount,
      dueDate: json['dueDate']?.toString() ?? json['dueAt']?.toString() ?? json['createdAt']?.toString() ?? '',
      cardBrand: brand,
      cardLast4: last4,
      referenceNumber: json['referenceNumber']?.toString() ?? json['reference']?.toString() ?? json['ref']?.toString(),
      paidAt: json['paidAt']?.toString(),
      receiptUrl: json['receiptUrl']?.toString() ?? json['receipt']?.toString(),
      status: parsedStatus,
    );
  }
}

