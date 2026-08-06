import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../services/customer_service.dart';
import '../../../services/auth_service.dart';
import '../models/profile_model.dart';

class ProfileProvider extends ChangeNotifier {
  final CustomerService _customerService = CustomerService();
  final AuthService _authService = AuthService();

  ProfileModel? profile;
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  Future<void> loadProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await _customerService.getProfile();
      profile = ProfileModel.fromJson(data);
    } catch (e) {
      print('PROFILE ERROR: $e');
      error = 'حدث خطأ في تحميل البيانات';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String legalName,
    required String mobileNumber,
    required String nationalIdNumber,
    required DateTime dateOfBirth,
    required String governorate,
    required String city,
    required String streetAddress,
  }) async {
    isSaving = true;
    error = null;
    notifyListeners();

    try {
      final isoDate =
          '${dateOfBirth.year.toString().padLeft(4, '0')}-${dateOfBirth.month.toString().padLeft(2, '0')}-${dateOfBirth.day.toString().padLeft(2, '0')}';

      await _customerService.updateProfile(
        legalName: legalName,
        mobileNumber: mobileNumber,
        nationalIdNumber: nationalIdNumber,
        dateOfBirthIso: isoDate,
        governorate: governorate,
        city: city,
        streetAddress: streetAddress,
      );

      if (profile != null) {
        profile = profile!.copyWith(
          name: legalName,
          phone: mobileNumber,
          address: '$streetAddress، $city، $governorate',
          birthDate:
              '${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}',
        );
      }
      return true;
    } catch (e) {
      if (e is DioException) {
        print(
          'PROFILE UPDATE ERROR: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        print('PROFILE UPDATE ERROR: $e');
      }
      error = 'فشل حفظ التعديلات';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await _authService.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    } catch (e) {
      error = 'فشل تسجيل الخروج';
      notifyListeners();
    }
  }
}
