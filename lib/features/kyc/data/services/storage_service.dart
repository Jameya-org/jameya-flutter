import 'dart:io';

import 'package:dio/dio.dart';

import '../models/storage_upload_result.dart';

/// Document types that must NOT accept PDF files.
const _imageOnlyDocTypes = {
  'NATIONAL_ID',
  'PASSPORT',
  'CAR_LICENSE',
  'SYNDICATE_ID',
};

/// Maximum allowed file size in bytes (10 MB).
const _maxFileSizeBytes = 10 * 1024 * 1024;

/// Service responsible for uploading physical files to cloud storage via
/// POST /storage/upload (multipart/form-data).
///
/// This is STEP 1 of the two-step document upload flow:
///   1. [upload] → returns [StorageUploadResult.secureUrl]
///   2. KycService.uploadDocument(encryptedObjectRef: secureUrl)
class StorageService {
  StorageService(this.dio);
  final Dio dio;

  /// Uploads [file] to cloud storage for the given [docType].
  ///
  /// Performs client-side validation before sending the request:
  /// - File size must be ≤ 10 MB.
  /// - PDF files are rejected for image-only doc types:
  ///   NATIONAL_ID, PASSPORT, CAR_LICENSE, SYNDICATE_ID.
  ///
  /// Returns a [StorageUploadResult] whose [StorageUploadResult.secureUrl]
  /// MUST be passed as `encryptedObjectRef` to the document registration call.
  ///
  /// Throws a [StorageValidationException] on client-side validation failure.
  /// Re-throws [DioException] on network / server failure so callers can
  /// extract the backend message directly.
  Future<StorageUploadResult> upload({
    required String docType,
    required File file,
  }) async {
    // ── Client-side validation ──────────────────────────────────────────────

    final fileSize = await file.length();
    if (fileSize > _maxFileSizeBytes) {
      throw StorageValidationException(
        'حجم الملف يتجاوز الحد المسموح به (10 ميجابايت). '
        'الحجم الحالي: ${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB.',
      );
    }

    final isPdf = file.path.toLowerCase().endsWith('.pdf');
    if (isPdf && _imageOnlyDocTypes.contains(docType)) {
      throw const StorageValidationException(
        'نوع الملف PDF غير مقبول لهذا النوع من المستندات. '
        'يُرجى اختيار صورة بدلاً من ذلك.',
      );
    }

    // ── Upload ──────────────────────────────────────────────────────────────

    final fileName = file.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'docType': docType,
      'file': await MultipartFile.fromFile(file.path, filename: fileName),
    });

    try {
      final response = await dio.post(
        '/storage/upload',
        data: formData,
        options: Options(
          // Override the default application/json content-type so Dio sets
          // multipart/form-data with the correct boundary automatically.
          contentType: 'multipart/form-data',
        ),
      );

      final data = response.data;
      final Map<String, dynamic> json;
      if (data is Map<String, dynamic>) {
        json = data;
      } else if (data is Map) {
        json = Map<String, dynamic>.from(data);
      } else {
        throw const StorageValidationException(
          'فشل رفع الملف: استجابة غير متوقعة من الخادم.',
        );
      }

      final result = StorageUploadResult.fromJson(json);

      // ── Strict secureUrl validation ─────────────────────────────────────
      if (result.secureUrl.isEmpty) {
        throw const StorageValidationException(
          'فشل رفع الملف: لم يتم استلام رابط الملف من الخادم.',
        );
      }

      return result;
    } on DioException {
      rethrow;
    }
  }
}

/// Thrown when client-side storage validation fails (size, type, etc.)
/// or when the server returns a malformed response (missing secureUrl).
class StorageValidationException implements Exception {
  const StorageValidationException(this.message);
  final String message;

  @override
  String toString() => message;
}
