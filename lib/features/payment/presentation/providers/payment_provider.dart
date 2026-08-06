import 'package:flutter/material.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/payment_method_model.dart';
import '../../data/services/payment_service.dart';

class PaymentProvider extends ChangeNotifier {
  final PaymentService _service = getIt<PaymentService>();

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
      return false;
    }
  }

  Future<bool> deleteCard(String id) async {
    try {
      await _service.deleteCard(id);
      await loadCards();
      return true;
    } catch (e) {
      return false;
    }
  }
}
