import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/dio_error_utils.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/kyc_status_model.dart';
import '../../data/services/kyc_service.dart';
import '../../data/services/storage_service.dart';

class KycProvider extends ChangeNotifier {
  final KycService _kycService = getIt<KycService>();
  final StorageService _storageService = getIt<StorageService>();

  // ── State ────────────────────────────────────────────────────────────────

  KycStatusModel? kycStatus;

  /// True while GET /customers/kyc-status is in progress.
  bool isLoading = false;

  String? error;

  /// Tracks which doc types are currently in the STORAGE UPLOAD phase.
  final Set<String> _uploadingToStorage = {};

  /// Tracks which doc types are currently in the DOCUMENT REGISTRATION phase.
  final Set<String> _registeringDocument = {};

  /// Locally selected files (PlatformFile) before upload, keyed by docType.
  ///
  /// Replacing an entry is safe and never throws — [setDocumentFile] is an
  /// atomic map assignment that replaces any previous selection.
  final Map<String, PlatformFile> _selectedFiles = {};

  /// Holds secureUrls from successful storage uploads that are waiting for
  /// document registration. Kept in memory so the user can retry registration
  /// without uploading the file again.
  ///
  /// Key: docType — Value: secureUrl returned by POST /storage/upload.
  final Map<String, String> _pendingSecureUrls = {};

  /// Issue dates selected for each docType.
  final Map<String, DateTime> _issueDates = {};

  /// Expiry dates selected for each docType.
  final Map<String, DateTime> _expiryDates = {};

  // ── Getters ───────────────────────────────────────────────────────────────

  /// Convenience accessor for the parsed status enum.
  KycStatus get status => kycStatus?.status ?? KycStatus.notVerified;

  /// Returns the locally selected file path for [docType], or null.
  String? selectedFilePath(String docType) => _selectedFiles[docType]?.path;

  /// Returns the selected issue date for [docType], or null.
  DateTime? issueDate(String docType) => _issueDates[docType];

  /// Returns the selected expiry date for [docType], or null.
  DateTime? expiryDate(String docType) => _expiryDates[docType];

  /// Returns true while the file for [docType] is being uploaded to storage.
  bool isUploadingToStorage(String docType) =>
      _uploadingToStorage.contains(docType);

  /// Returns true while the document record for [docType] is being registered.
  bool isRegisteringDocument(String docType) =>
      _registeringDocument.contains(docType);

  /// Returns true when either upload phase is active for [docType].
  bool isUploading(String docType) =>
      isUploadingToStorage(docType) || isRegisteringDocument(docType);

  /// Returns true when a secureUrl is already stored for [docType] (i.e.
  /// storage upload succeeded but registration has not completed yet).
  bool hasSecureUrl(String docType) =>
      _pendingSecureUrls.containsKey(docType);

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Sets the issue date for [docType].
  void setIssueDate(String docType, DateTime date) {
    _issueDates[docType] = date;
    notifyListeners();
  }

  /// Sets the expiry date for [docType].
  void setExpiryDate(String docType, DateTime date) {
    _expiryDates[docType] = date;
    notifyListeners();
  }

  /// Loads / refreshes GET /customers/kyc-status.
  /// Always called on screen open and after any mutation.
  Future<void> loadStatus() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final data = await _kycService.getKycStatus();
      kycStatus = KycStatusModel.fromJson(data);
    } on DioException catch (e) {
      error = dioErrorMessage(e, fallback: 'حدث خطأ في تحميل حالة التوثيق');
    } catch (_) {
      error = 'حدث خطأ في تحميل حالة التوثيق';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Atomically replaces the locally selected file for [docType].
  ///
  /// Document replacement fix: calling this multiple times simply overwrites
  /// the previous entry — no exception, no stale reference, UI previews
  /// the new file immediately.
  ///
  /// Also clears any cached secureUrl for this docType so the next submit
  /// triggers a fresh storage upload with the newly selected file.
  void setDocumentFile(String docType, PlatformFile file) {
    _selectedFiles[docType] = file;
    // Clear any previously stored secureUrl since the user selected a new file.
    _pendingSecureUrls.remove(docType);
    notifyListeners();
  }

  /// Clears the locally selected file and dates for [docType].
  void clearDocumentFile(String docType) {
    _selectedFiles.remove(docType);
    _pendingSecureUrls.remove(docType);
    _issueDates.remove(docType);
    _expiryDates.remove(docType);
    notifyListeners();
  }

  /// Two-step document upload:
  ///
  /// STEP 1 — POST /storage/upload:
  ///   - Skipped if a valid [secureUrl] already exists in [_pendingSecureUrls]
  ///     for this [docType] (retry-without-re-upload scenario).
  ///   - On failure: stops, returns error, does NOT call Step 2.
  ///
  /// STEP 2 — POST /customers/documents:
  ///   - Uses the secureUrl from Step 1 (or the cached one on retry).
  ///   - Passes issueDate and expiryDate formatted as ISO YYYY-MM-DD strings.
  ///   - On failure: keeps [secureUrl] in memory and keeps the file selected
  ///     so the user can retry without choosing the file again.
  ///   - On success: clears selected file + secureUrl, refreshes KYC status.
  ///
  /// Returns `null` on full success or an error message string on failure.
  Future<String?> uploadDocument({
    required String docType,
    String? issueDate,
    String? expiryDate,
  }) async {
    // ── STEP 1: Storage Upload ───────────────────────────────────────────

    // Check if we already have a valid secureUrl from a previous upload
    // attempt (retry-without-re-upload scenario).
    String? secureUrl = _pendingSecureUrls[docType];

    if (secureUrl == null) {
      // No cached secureUrl — must upload the file first.
      final platformFile = _selectedFiles[docType];
      if (platformFile == null || platformFile.path == null) {
        return 'لم يتم اختيار ملف لهذا النوع من المستندات.';
      }

      _uploadingToStorage.add(docType);
      error = null;
      notifyListeners();

      try {
        final result = await _storageService.upload(
          docType: docType,
          file: File(platformFile.path!),
        );

        // Validate secureUrl strictly.
        if (result.secureUrl.isEmpty) {
          const msg = 'فشل رفع الملف: لم يتم استلام رابط الملف من الخادم.';
          error = msg;
          notifyListeners();
          return msg;
        }

        // Cache secureUrl in memory for potential retry.
        secureUrl = result.secureUrl;
        _pendingSecureUrls[docType] = secureUrl;
      } on StorageValidationException catch (e) {
        final msg = e.message;
        error = msg;
        notifyListeners();
        return msg;
      } on DioException catch (e) {
        final msg = dioErrorMessage(e, fallback: 'فشل رفع الملف إلى التخزين');
        error = msg;
        notifyListeners();
        return msg;
      } catch (_) {
        const msg = 'فشل رفع الملف إلى التخزين';
        error = msg;
        notifyListeners();
        return msg;
      } finally {
        _uploadingToStorage.remove(docType);
        notifyListeners();
      }
    }

    // ── STEP 2: Document Registration ────────────────────────────────────

    _registeringDocument.add(docType);
    error = null;
    notifyListeners();

    try {
      final formattedIssueDate =
          issueDate ?? _formatIsoDate(_issueDates[docType]);
      final formattedExpiryDate =
          expiryDate ?? _formatIsoDate(_expiryDates[docType]);

      await _kycService.uploadDocument(
        docType: docType,
        encryptedObjectRef: secureUrl,
        issueDate: formattedIssueDate,
        expiryDate: formattedExpiryDate,
      );

      // Full success: clear local state.
      _selectedFiles.remove(docType);
      _pendingSecureUrls.remove(docType);
      _issueDates.remove(docType);
      _expiryDates.remove(docType);

      // Refresh KYC status immediately so the UI reflects the new document.
      await loadStatus();
      return null;
    } on DioException catch (e) {
      // Registration failed — keep secureUrl + file selected so the user
      // can retry without re-uploading the file.
      final msg = dioErrorMessage(e, fallback: 'فشل تسجيل المستند');
      error = msg;
      notifyListeners();
      return msg;
    } catch (_) {
      const msg = 'فشل تسجيل المستند';
      error = msg;
      notifyListeners();
      return msg;
    } finally {
      _registeringDocument.remove(docType);
      notifyListeners();
    }
  }

  /// POST /customers/kyc/submit
  ///
  /// Returns `null` on success or the exact backend error message on failure.
  Future<String?> submitKyc() async {
    error = null;
    notifyListeners();

    try {
      await _kycService.submitForReview();
      // Refresh KYC status after submission.
      await loadStatus();
      return null;
    } on DioException catch (e) {
      // Preserve the exact backend message (e.g. "A proof of income document
      // is required before submitting (PROOF_OF_INCOME).").
      final msg = dioErrorMessage(e, fallback: 'فشل إرسال طلب التوثيق');
      error = msg;
      notifyListeners();
      return msg;
    } catch (_) {
      const msg = 'فشل إرسال طلب التوثيق';
      error = msg;
      notifyListeners();
      return msg;
    }
  }

  static String? _formatIsoDate(DateTime? date) {
    if (date == null) return null;
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
