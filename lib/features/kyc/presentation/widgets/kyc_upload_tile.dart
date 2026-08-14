import 'package:flutter/material.dart';

class KycUploadTile extends StatelessWidget {
  const KycUploadTile({
    super.key,
    required this.label,
    this.isUploaded = false,
    this.selectedPath,
    this.isUploadingToStorage = false,
    this.isRegisteringDocument = false,
    this.onTap,
    this.requiresDates = false,
    this.issueDate,
    this.expiryDate,
    this.onPickIssueDate,
    this.onPickExpiryDate,
  });

  final String label;

  /// True when the backend has already accepted this document.
  final bool isUploaded;

  /// Path of the locally selected (but not yet uploaded) file, or null.
  final String? selectedPath;

  /// True while this document's physical file is being uploaded to storage.
  final bool isUploadingToStorage;

  /// True while this document record is being registered with the backend.
  final bool isRegisteringDocument;

  /// Called when the tile is tapped to pick a file.
  final VoidCallback? onTap;

  /// Whether this document type requires issue and expiry dates.
  final bool requiresDates;

  /// Selected issue date.
  final DateTime? issueDate;

  /// Selected expiry date.
  final DateTime? expiryDate;

  /// Called to pick the issue date.
  final VoidCallback? onPickIssueDate;

  /// Called to pick the expiry date.
  final VoidCallback? onPickExpiryDate;

  bool get _isBusy => isUploadingToStorage || isRegisteringDocument;

  static String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

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

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: isDone ? const Color(0xFF1A7A6E) : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isDone ? const Color(0xFFE8F6F3) : Colors.grey.shade50,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: _isBusy ? null : onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
          ),
          if (requiresDates && hasLocalFile && !isUploaded) ...[
            const Divider(height: 1, indent: 16, endIndent: 16),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        side: BorderSide(
                          color: issueDate != null
                              ? const Color(0xFF1A7A6E)
                              : Colors.red.shade300,
                        ),
                      ),
                      onPressed: _isBusy ? null : onPickIssueDate,
                      icon: const Icon(Icons.calendar_today, size: 14),
                      label: Text(
                        issueDate != null
                            ? 'إصدار: ${_formatDate(issueDate!)}'
                            : 'تاريخ الإصدار *',
                        style: TextStyle(
                          fontSize: 11,
                          color: issueDate != null
                              ? const Color(0xFF1A7A6E)
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                        side: BorderSide(
                          color: expiryDate != null
                              ? const Color(0xFF1A7A6E)
                              : Colors.red.shade300,
                        ),
                      ),
                      onPressed: _isBusy ? null : onPickExpiryDate,
                      icon: const Icon(Icons.event, size: 14),
                      label: Text(
                        expiryDate != null
                            ? 'انتهاء: ${_formatDate(expiryDate!)}'
                            : 'تاريخ الانتهاء *',
                        style: TextStyle(
                          fontSize: 11,
                          color: expiryDate != null
                              ? const Color(0xFF1A7A6E)
                              : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
