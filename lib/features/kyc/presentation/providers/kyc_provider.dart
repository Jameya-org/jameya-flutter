import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/dio_error_utils.dart';
import '../../../../core/services/services_locator.dart';
import '../../data/models/kyc_status_model.dart';
import '../../data/services/kyc_service.dart';

class KycProvider extends ChangeNotifier {
  final KycService _service = getIt<KycService>();

  // ── State ────────────────────────────────────────────────────────────────

  KycStatusModel? kycStatus;
  bool isLoading = false;
  String? error;

  /// Tracks which doc types are currently uploading.
  final Set<String> _uploadingTypes = {};

  /// Locally selected files before upload, keyed by docType.
  /// Replacing an entry is safe and never throws.
  final Map<String, String> _selectedFiles = {};

  // ── Getters ───────────────────────────────────────────────────────────────

  /// Convenience accessor for the parsed status enum.
  KycStatus get status => kycStatus?.status ?? KycStatus.notVerified;

  /// Returns the locally selected file path for [docType], or null.
  String? selectedFilePath(String docType) => _selectedFiles[docType];

  /// Returns true while an upload for [docType] is in progress.
  bool isUploading(String docType) => _uploadingTypes.contains(docType);

  // ── Actions ───────────────────────────────────────────────────────────────

  /// Loads / refreshes GET /customers/kyc-status.
  /// Always called on screen open and after any mutation.
  Future<void> loadStatus() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final data = await _service.getKycStatus();
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
  /// This is the fix for the replacement bug: calling this multiple times
  /// before submission simply overwrites the previous entry — no exception,
  /// no stale reference.
  void setDocumentFile(String docType, String filePath) {
    _selectedFiles[docType] = filePath;
    notifyListeners();
  }

  /// Clears the locally selected file for [docType].
  void clearDocumentFile(String docType) {
    _selectedFiles.remove(docType);
    notifyListeners();
  }

  /// POST /customers/documents
  ///
  /// Uploads the document for [docType] and then refreshes KYC status so
  /// the UI reflects the new document immediately.
  ///
  /// Returns `null` on success or an error message string on failure.
  Future<String?> uploadDocument({
    required String docType,
    required String encryptedObjectRef,
    required String issueDate,
    required String expiryDate,
  }) async {
    _uploadingTypes.add(docType);
    error = null;
    notifyListeners();

    try {
      await _service.uploadDocument(
        docType: docType,
        encryptedObjectRef: encryptedObjectRef,
        issueDate: issueDate,
        expiryDate: expiryDate,
      );
      // Clear local selection after successful upload
      _selectedFiles.remove(docType);
      // Refresh KYC status immediately so the UI updates
      await loadStatus();
      return null;
    } on DioException catch (e) {
      final msg = dioErrorMessage(e, fallback: 'فشل رفع المستند');
      error = msg;
      notifyListeners();
      return msg;
    } catch (_) {
      const msg = 'فشل رفع المستند';
      error = msg;
      notifyListeners();
      return msg;
    } finally {
      _uploadingTypes.remove(docType);
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
      await _service.submitForReview();
      // Refresh KYC status after submission
      await loadStatus();
      return null;
    } on DioException catch (e) {
      // Preserve the exact backend message (e.g. "A proof of income document
      // is required before submitting (PROOF_OF_INCOME).")
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
}
