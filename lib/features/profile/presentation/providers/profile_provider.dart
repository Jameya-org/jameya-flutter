import 'package:flutter/material.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/profile_model.dart';
import '../../data/services/customer_service.dart';

class ProfileProvider extends ChangeNotifier {
  final CustomerService _customerService = getIt<CustomerService>();

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
      error = 'فشل حفظ التعديلات';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await getIt<CacheHelper>().clearAllData();
      await getIt<CacheHelper>().deleteAllSecureData();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }
    } catch (e) {
      error = 'فشل تسجيل الخروج';
      notifyListeners();
    }
  }
}
