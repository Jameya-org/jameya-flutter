import 'package:flutter/material.dart';

class KycUploadTile extends StatelessWidget {
  final String label;

  /// True when the backend has already accepted this document.
  final bool isUploaded;

  /// Path of the locally selected (but not yet uploaded) file, or null.
  final String? selectedPath;

  /// True while this document's physical file is being uploaded to storage.
  final bool isUploadingToStorage;

  /// True while this document record is being registered with the backend.
  final bool isRegisteringDocument;

  /// Called when the tile is tapped. Null when [isUploaded] is true or
  /// when any upload phase is in progress.
  final VoidCallback? onTap;

  const KycUploadTile({
    super.key,
    required this.label,
    this.isUploaded = false,
    this.selectedPath,
    this.isUploadingToStorage = false,
    this.isRegisteringDocument = false,
    this.onTap,
  });

  bool get _isBusy => isUploadingToStorage || isRegisteringDocument;

  @override
  Widget build(BuildContext context) {
    final hasLocalFile = selectedPath != null && selectedPath!.isNotEmpty;
    final isDone = isUploaded || hasLocalFile;

    String statusLabel;
    if (isUploadingToStorage) {
      statusLabel = 'جاري رفع الملف...';
    } else if (isRegisteringDocument) {
      statusLabel = 'جاري تسجيل المستند...';
    } else if (isUploaded) {
      statusLabel = 'تم الرفع بنجاح';
    } else if (hasLocalFile) {
      statusLabel = 'تم اختيار الملف — اضغط للتغيير';
    } else {
      statusLabel = 'اضغط لرفع الملف';
    }

    return InkWell(
      onTap: _isBusy ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          border: Border.all(
            color: isDone ? const Color(0xFF1A7A6E) : Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isDone ? const Color(0xFFE8F6F3) : Colors.grey.shade50,
        ),
        child: Column(
          children: [
            if (_isBusy)
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF1A7A6E),
                ),
              )
            else
              CircleAvatar(
                backgroundColor: const Color(0xFFD6EAF8),
                child: Icon(
                  isUploaded
                      ? Icons.cloud_done
                      : hasLocalFile
                          ? Icons.check
                          : Icons.upload_file_outlined,
                  color: const Color(0xFF1A7A6E),
                ),
              ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              statusLabel,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            ),
          ],
        ),
      ),
    );
  }
}
