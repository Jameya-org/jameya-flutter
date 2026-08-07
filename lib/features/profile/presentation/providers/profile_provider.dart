import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/cache/cache_helper.dart';
import '../../../../core/cache/cache_keys.dart';
import '../../../../core/network/dio_error_utils.dart';
import '../../../../core/routing/routes.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/profile_model.dart';
import '../../data/services/customer_service.dart';
import '../../../kyc/presentation/providers/kyc_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final CustomerService _customerService = getIt<CustomerService>();

  ProfileModel? profile;
  bool isLoading = false;
  bool isSaving = false;
  String? error;

  // ── Load ───────────────────────────────────────────────────────────────

  /// Loads / refreshes GET /customers/profile.
  ///
  /// 1. Immediately restores any cached profile so the UI is not blank.
  /// 2. Fetches fresh data from the server.
  /// 3. Merges remote with cached to avoid flashing empty fields.
  /// 4. Syncs all profile fields to local cache (email, legalName, phone).
  Future<void> loadProfile() async {
    isLoading = true;
    error = null;
    notifyListeners();

    _applyCachedProfile();

    try {
      final data = await _customerService.getProfile();
      final remote = ProfileModel.fromJson(data);
      profile = _mergeWithCached(remote);
      // Always sync cache so local data stays current.
      await _cacheProfile(profile!);
    } on DioException catch (e) {
      if (profile == null) {
        error = dioErrorMessage(e, fallback: 'حدث خطأ في تحميل البيانات');
      }
    } catch (_) {
      if (profile == null) {
        error = 'حدث خطأ في تحميل البيانات';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // ── Update ─────────────────────────────────────────────────────────────

  /// POST /customers/profile — creates or updates the identity profile.
  ///
  /// On success:
  ///  1. Re-fetches GET /customers/profile so the local state always
  ///     reflects the exact server response (no local copyWith guessing).
  ///  2. Refreshes GET /customers/kyc-status via [KycProvider] so the
  ///     identity profile and KYC state are always up-to-date.
  ///
  /// On failure: surfaces the exact backend error message.
  Future<bool> updateProfile({
    required BuildContext context,
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
          '${dateOfBirth.year.toString().padLeft(4, '0')}-'
          '${dateOfBirth.month.toString().padLeft(2, '0')}-'
          '${dateOfBirth.day.toString().padLeft(2, '0')}';

      await _customerService.updateProfile(
        legalName: legalName,
        mobileNumber: mobileNumber,
        nationalIdNumber: nationalIdNumber,
        dateOfBirthIso: isoDate,
        governorate: governorate,
        city: city,
        streetAddress: streetAddress,
      );

      // Re-fetch fresh profile from server — replaces the old manual copyWith.
      // loadProfile() also syncs the local cache internally.
      await loadProfile();

      // Refresh KYC status so identity profile info is current.
      if (context.mounted) {
        // Fire and forget — we don't await this so the profile save response
        // is immediate; KYC refreshes in the background.
        context.read<KycProvider>().loadStatus();
      }

      return true;
    } on DioException catch (e) {
      error = dioErrorMessage(e, fallback: 'فشل حفظ التعديلات');
      return false;
    } catch (_) {
      error = 'فشل حفظ التعديلات';
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  // ── Logout ─────────────────────────────────────────────────────────────

  Future<void> logout(BuildContext context) async {
    try {
      final cache = getIt<CacheHelper>();
      await cache.deleteData(key: CacheKeys.accessToken);
      await cache.deleteData(key: CacheKeys.refreshToken);
      await cache.deleteData(key: CacheKeys.email);
      await cache.deleteData(key: CacheKeys.legalName);
      await cache.deleteData(key: CacheKeys.phone);
      await cache.deleteAllSecureData();
      profile = null;
      if (context.mounted) {
        context.go(AppRoutes.kEmailView);
      }
    } catch (_) {
      error = 'فشل تسجيل الخروج';
      notifyListeners();
    }
  }

  // ── Cache helpers ──────────────────────────────────────────────────────

  /// Restores basic profile fields from local cache on startup.
  void _applyCachedProfile() {
    final cache = getIt<CacheHelper>();
    final email = cache.getString(key: CacheKeys.email);
    final legalName = cache.getString(key: CacheKeys.legalName);
    final phone = cache.getString(key: CacheKeys.phone);

    if (email == null && legalName == null && phone == null) return;

    profile = ProfileModel(
      legalName: legalName ?? '',
      email: email ?? '',
      mobileNumber: phone ?? '',
    );
  }

  /// Merges the API response with locally cached values for fields the API
  /// may not always return.
  ProfileModel _mergeWithCached(ProfileModel remote) {
    final cached = profile;
    if (cached == null) return remote;
    return ProfileModel(
      id: remote.id.isNotEmpty ? remote.id : cached.id,
      legalName: remote.legalName.isNotEmpty ? remote.legalName : cached.legalName,
      email: remote.email.isNotEmpty ? remote.email : cached.email,
      mobileNumber: remote.mobileNumber.isNotEmpty
          ? remote.mobileNumber
          : cached.mobileNumber,
      status: remote.status,
      locale: remote.locale,
      createdAt: remote.createdAt,
    );
  }

  /// Writes every profile field to local cache.
  ///
  /// All three keys are always written (never skipped) to ensure the cache
  /// stays fully synchronized with the latest server data.
  Future<void> _cacheProfile(ProfileModel value) async {
    final cache = getIt<CacheHelper>();
    await cache.saveData(key: CacheKeys.email, value: value.email);
    await cache.saveData(key: CacheKeys.legalName, value: value.legalName);
    // Always write phone — even if empty — to clear any stale value.
    await cache.saveData(key: CacheKeys.phone, value: value.mobileNumber);
  }
}
