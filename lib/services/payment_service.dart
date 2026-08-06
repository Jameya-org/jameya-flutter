import 'package:jameya_user/core/api_client.dart';

class PaymentService {
  final ApiClient _apiClient = ApiClient();

  Future<List<Map<String, dynamic>>> getPaymentMethods() async {
    final response = await _apiClient.dio.get('/customer/payment-methods');
    final data = response.data;
    if (data is List) return List<Map<String, dynamic>>.from(data);
    if (data is Map && data['items'] is List) {
      return List<Map<String, dynamic>>.from(data['items']);
    }
    return [];
  }

  /// cardToken بييجي من SDK بوابة الدفع بعد ما المستخدم يدخل بيانات الكارت
  /// هناك (مش من عندنا) — إحنا هنا بس بنبعت التوكن للباك اند يحفظه
  Future<void> verifyAndSaveCard({
    required String cardToken,
    required String cardHolderName,
  }) async {
    await _apiClient.dio.post(
      '/customer/payment-methods/verify',
      data: {'cardToken': cardToken, 'cardHolderName': cardHolderName},
    );
  }

  Future<void> setDefault(String id) async {
    await _apiClient.dio.patch('/customer/payment-methods/$id/set-default');
  }

  Future<void> deleteCard(String id) async {
    await _apiClient.dio.delete('/customer/payment-methods/$id');
  }
}
