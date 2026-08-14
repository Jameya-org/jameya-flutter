import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/token_utils.dart';
import '../../data/models/profile_model.dart';
import '../../data/services/customer_service.dart';

class ProfileProvider extends ChangeNotifier {
  final CustomerService _customerService = getIt<CustomerService>();
  final CacheHelper _cacheHelper = getIt<CacheHelper>();

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
      debugPrint('PROFILE ERROR: $e');
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
          legalName: legalName,
          mobileNumber: mobileNumber,
        );
      }
      return true;
    } catch (e) {
      if (e is DioException) {
        debugPrint(
          'PROFILE UPDATE ERROR: ${e.response?.statusCode} - ${e.response?.data}',
        );
      } else {
        debugPrint('PROFILE UPDATE ERROR: $e');
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
      await TokenUtils.clearTokens(_cacheHelper);
      if (context.mounted) {
        context.go(AppRoutes.kEmailView);
      }
    } catch (e) {
      error = 'فشل تسجيل الخروج';
      notifyListeners();
    }
  }
}
