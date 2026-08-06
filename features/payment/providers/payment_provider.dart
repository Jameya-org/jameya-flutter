import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../services/payment_service.dart';
import '../models/payment_method_model.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _service = PaymentService();

  List<PaymentMethodModel> cards = [];
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  Future<void> loadCards() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final data = await _service.getPaymentMethods();
      cards = data.map((e) => PaymentMethodModel.fromJson(e)).toList();
    } catch (e) {
      print('PAYMENT LOAD ERROR: $e');
      error = 'حدث خطأ في تحميل البطاقات';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveCard({
    required String cardToken,
    required String cardHolderName,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();
    try {
      await _service.verifyAndSaveCard(
        cardToken: cardToken,
        cardHolderName: cardHolderName,
      );
      await loadCards();
      return true;
    } catch (e) {
      if (e is DioException) {
        print(
          'PAYMENT SAVE ERROR: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        print('PAYMENT SAVE ERROR: $e');
      }
      error = 'فشل حفظ البطاقة';
      isSaving = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> setDefault(String id) async {
    try {
      await _service.setDefault(id);
      await loadCards();
      return true;
    } catch (e) {
      print('PAYMENT SET DEFAULT ERROR: $e');
      return false;
    }
  }

  Future<bool> deleteCard(String id) async {
    try {
      await _service.deleteCard(id);
      await loadCards();
      return true;
    } catch (e) {
      print('PAYMENT DELETE ERROR: $e');
      return false;
    }
  }
}
