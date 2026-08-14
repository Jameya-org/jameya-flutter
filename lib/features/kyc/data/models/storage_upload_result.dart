/// Model for the response returned by POST /storage/upload.
///
/// After a successful file upload the backend returns:
/// ```json
/// {
///   "secureUrl": "...",
///   "publicId": "...",
///   "docType": "...",
///   "message": "File uploaded successfully. Use secureUrl as encryptedObjectRef in POST /customers/documents."
/// }
/// ```
///
/// The [secureUrl] MUST be passed as [encryptedObjectRef] in the subsequent
/// POST /customers/documents call.
class StorageUploadResult {
  const StorageUploadResult({
    required this.secureUrl,
    required this.publicId,
    required this.docType,
    required this.message,
  });

  factory StorageUploadResult.fromJson(Map<String, dynamic> json) {
    return StorageUploadResult(
      secureUrl: json['secureUrl']?.toString() ?? '',
      publicId: json['publicId']?.toString() ?? '',
      docType: json['docType']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
    );
  }
  final String secureUrl;
  final String publicId;
  final String docType;
  final String message;
}
