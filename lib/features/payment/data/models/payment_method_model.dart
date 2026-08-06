class PaymentMethodModel {
  final String id;
  final String cardHolderName;
  final String last4;
  final String brand;
  final String expiryMonth;
  final String expiryYear;
  final bool isDefault;

  PaymentMethodModel({
    required this.id,
    required this.cardHolderName,
    required this.last4,
    required this.brand,
    required this.expiryMonth,
    required this.expiryYear,
    required this.isDefault,
  });

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id']?.toString() ?? '',
      cardHolderName: json['cardHolderName'] ?? '',
      last4: json['last4'] ?? '',
      brand: json['brand'] ?? '',
      expiryMonth: json['expiryMonth']?.toString() ?? '',
      expiryYear: json['expiryYear']?.toString() ?? '',
      isDefault: json['isDefault'] ?? false,
    );
  }
}
