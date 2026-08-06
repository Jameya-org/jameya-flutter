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
}
