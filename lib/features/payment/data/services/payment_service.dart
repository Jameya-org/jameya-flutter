import 'package:dio/dio.dart';

class PaymentService {
  final Dio dio;

  PaymentService(this.dio);

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final response = await dio.get('/customer/payment-methods');
    final data = response.data;
    if (data is List) return List<Map<String, dynamic>>.from(data);
    if (data is Map && data['items'] is List) {
      return List<Map<String, dynamic>>.from(data['items']);
    }
    return [];
  }

  Future<void> verifyAndSaveCard({
    required String cardToken,
    required String cardHolderName,
  }) async {
    await dio.post(
      '/customer/payment-methods/verify',
      data: {'cardToken': cardToken, 'cardHolderName': cardHolderName},
    );
  }

  Future<void> setDefault(String id) async {
    await dio.patch('/customer/payment-methods/$id/set-default');
  }

  Future<void> deleteCard(String id) async {
    await dio.delete('/customer/payment-methods/$id');
  }

  // ── Customer Installments (FR-11 & Payments) ─────────────────

  /// GET /customer/installments
  /// Returns current balance, next due, and full schedule by circle
  Future<Map<String, dynamic>> getInstallments() async {
    final response = await dio.get('/customer/installments');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  /// GET /customer/installments/history
  /// Returns unified payment and transaction history timeline (سجل المعاملات)
  Future<List<Map<String, dynamic>>> getInstallmentsHistory() async {
    final response = await dio.get('/customer/installments/history');
    final data = response.data;
    if (data is List) return List<Map<String, dynamic>>.from(data);
    if (data is Map && data['data'] is List) {
      return List<Map<String, dynamic>>.from(data['data']);
    }
    if (data is Map && data['items'] is List) {
      return List<Map<String, dynamic>>.from(data['items']);
    }
    return [];
  }

  /// GET /customer/installments/{id}
  /// Returns single installment details, attempt history, and receipt if paid
  Future<Map<String, dynamic>> getInstallmentDetail(String id) async {
    final response = await dio.get('/customer/installments/$id');
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  /// POST /customer/installments/{id}/pay
  /// Pay due installment immediately via customer linked payment method (ادفع الآن)
  Future<Map<String, dynamic>> payInstallment(
    String id, {
    String? paymentMethodId,
    String? cardToken,
  }) async {
    final body = <String, dynamic>{};
    if (paymentMethodId != null) body['paymentMethodId'] = paymentMethodId;
    if (cardToken != null) body['cardToken'] = cardToken;

    final response = await dio.post(
      '/customer/installments/$id/pay',
      data: body.isNotEmpty ? body : null,
    );
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }

  /// POST /customer/installments/{id}/submit-proof
  /// Submit manual payment proof (Vodafone Cash / InstaPay) - Feature Flagged
  Future<Map<String, dynamic>> submitManualProof(
    String id, {
    required String proofUrl,
    required String channel,
  }) async {
    final response = await dio.post(
      '/customer/installments/$id/submit-proof',
      data: {
        'proofUrl': proofUrl,
        'channel': channel,
      },
    );
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    if (data is Map) return Map<String, dynamic>.from(data);
    return {};
  }
}
