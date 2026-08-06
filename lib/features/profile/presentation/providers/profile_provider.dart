import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_key.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/routing/routes.dart';
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

    _applyCachedProfile();

    try {
      final data = await _customerService.getProfile();
      final remote = ProfileModel.fromJson(data);
      profile = _mergeWithCached(remote);
      await _cacheProfile(profile!);
    } catch (e) {
      if (profile == null) {
        error = 'حدث خطأ في تحميل البيانات';
      }
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

      if (profile == null) {
        _applyCachedProfile();
      }
      final base = profile ?? ProfileModel(name: legalName, email: '');
      profile = base.copyWith(
        name: legalName,
        phone: mobileNumber,
        nationalId: nationalIdNumber,
        address: '$streetAddress، $city، $governorate',
        birthDate:
            '${dateOfBirth.day}/${dateOfBirth.month}/${dateOfBirth.year}',
        governorate: governorate,
        city: city,
        streetAddress: streetAddress,
      );
      await _cacheProfile(profile!);
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
      final cache = getIt<CacheHelper>();
      // Clear the session tokens and persisted profile fields, but keep
      // non-session preferences (language, onboarding completion) intact.
      await cache.deleteData(key: CacheKey.accessToken);
      await cache.deleteData(key: CacheKey.refreshToken);
      await cache.deleteData(key: CacheKeys.email);
      await cache.deleteData(key: CacheKeys.legalName);
      await cache.deleteData(key: CacheKeys.phone);
      await cache.deleteData(key: CacheKeys.nationalId);
      await cache.deleteData(key: CacheKeys.birthDate);
      await cache.deleteData(key: CacheKeys.governorate);
      await cache.deleteData(key: CacheKeys.city);
      await cache.deleteData(key: CacheKeys.streetAddress);
      await cache.deleteAllSecureData();
      if (context.mounted) {
        context.go(AppRoutes.kEmailView);
      }
    } catch (e) {
      error = 'فشل تسجيل الخروج';
      notifyListeners();
    }
  }

  /// Loads locally persisted profile fields so data survives across launches.
  void _applyCachedProfile() {
    final cache = getIt<CacheHelper>();
    final email = cache.getString(key: CacheKeys.email);
    final name = cache.getString(key: CacheKeys.legalName);
    final phone = cache.getString(key: CacheKeys.phone);
    final nationalId = cache.getString(key: CacheKeys.nationalId);
    final birthDate = cache.getString(key: CacheKeys.birthDate);
    final governorate = cache.getString(key: CacheKeys.governorate);
    final city = cache.getString(key: CacheKeys.city);
    final street = cache.getString(key: CacheKeys.streetAddress);

    if (email == null && name == null && phone == null && nationalId == null) {
      return;
    }

    profile = ProfileModel(
      name: name ?? '',
      email: email ?? '',
      phone: phone,
      nationalId: nationalId,
      birthDate: birthDate,
      governorate: governorate,
      city: city,
      streetAddress: street,
    );
  }

  /// Merges the API profile with locally cached fields, keeping cached values
  /// for fields the API does not return.
  ProfileModel _mergeWithCached(ProfileModel remote) {
    final cached = profile;
    if (cached == null) return remote;
    return ProfileModel(
      name: remote.name.isNotEmpty ? remote.name : cached.name,
      email: remote.email.isNotEmpty ? remote.email : cached.email,
      phone: remote.phone ?? cached.phone,
      avatarUrl: remote.avatarUrl,
      kycStatus: remote.kycStatus,
      address: remote.address,
      birthDate: remote.birthDate ?? cached.birthDate,
      nationalId: cached.nationalId,
      governorate: cached.governorate,
      city: cached.city,
      streetAddress: cached.streetAddress,
    );
  }

  Future<void> _cacheProfile(ProfileModel value) async {
    final cache = getIt<CacheHelper>();
    await cache.saveData(key: CacheKeys.email, value: value.email);
    await cache.saveData(key: CacheKeys.legalName, value: value.name);
    if (value.phone != null) {
      await cache.saveData(key: CacheKeys.phone, value: value.phone!);
    }
    if (value.nationalId != null) {
      await cache.saveData(key: CacheKeys.nationalId, value: value.nationalId!);
    }
    if (value.birthDate != null) {
      await cache.saveData(key: CacheKeys.birthDate, value: value.birthDate!);
    }
    if (value.governorate != null) {
      await cache.saveData(
        key: CacheKeys.governorate,
        value: value.governorate!,
      );
    }
    if (value.city != null) {
      await cache.saveData(key: CacheKeys.city, value: value.city!);
    }
    if (value.streetAddress != null) {
      await cache.saveData(
        key: CacheKeys.streetAddress,
        value: value.streetAddress!,
      );
    }
  }
}