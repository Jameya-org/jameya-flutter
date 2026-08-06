import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../services/kyc_service.dart';
import '../models/kyc_status_model.dart';

class KycProvider extends ChangeNotifier {
  final KycService _service = KycService();

  KycStatusModel? kycStatus;
  bool isLoading = false;
  bool isSubmitting = false;
  String? error;

  File? nationalIdFile;
  File? incomeProofFile;

  Future<void> loadStatus() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final data = await _service.getKycStatus();
      kycStatus = KycStatusModel.fromJson(data);
    } catch (e) {
      print('KYC STATUS ERROR: $e');
      error = 'حدث خطأ في تحميل حالة التوثيق';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setNationalIdFile(File file) {
    nationalIdFile = file;
    notifyListeners();
  }

  void setIncomeProofFile(File file) {
    incomeProofFile = file;
    notifyListeners();
  }

  Future<bool> submitDocuments() async {
    if (nationalIdFile == null || incomeProofFile == null) {
      error = 'من فضلك ارفع كل المستندات المطلوبة';
      notifyListeners();
      return false;
    }

    isSubmitting = true;
    error = null;
    notifyListeners();

    try {
      await _service.uploadDocument(
        file: nationalIdFile!,
        documentType: 'NATIONAL_ID',
      );
      await _service.uploadDocument(
        file: incomeProofFile!,
        documentType: 'INCOME_PROOF',
      );
      await _service.submitForReview();
      await loadStatus();
      return true;
    } catch (e) {
      if (e is DioException) {
        print(
          'KYC SUBMIT ERROR: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        print('KYC SUBMIT ERROR: $e');
      }
      error = 'فشل إرسال المستندات';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }
}
