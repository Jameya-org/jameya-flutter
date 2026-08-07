import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/kyc_provider.dart';
import '../widgets/kyc_upload_tile.dart';

/// Arabic labels for each known document type.
/// Any future docType not listed here falls back to the raw docType string.
const _docTypeLabels = <String, String>{
  'NATIONAL_ID': 'الهوية الوطنية',
  'PASSPORT': 'جواز السفر',
  'PROOF_OF_INCOME': 'إثبات الدخل',
};

/// Document types that must NOT accept PDF files (image-only).
const _imageOnlyDocTypes = {
  'NATIONAL_ID',
  'PASSPORT',
  'CAR_LICENSE',
  'SYNDICATE_ID',
};

class KycUploadView extends StatefulWidget {
  final KycProvider provider;

  const KycUploadView({super.key, required this.provider});

  @override
  State<KycUploadView> createState() => _KycUploadViewState();
}

class _KycUploadViewState extends State<KycUploadView> {
  bool _isSubmitting = false;

  /// Picks a file for [docType] using the platform file picker and stores it
  /// in the provider.
  ///
  /// Document replacement fix: calling this multiple times simply overwrites
  /// the previous selection via [KycProvider.setDocumentFile]. The map entry
  /// is replaced atomically — no exception, no stale reference.
  ///
  /// Client-side validation:
  /// - PDF files are rejected for image-only document types.
  Future<void> _pickFile(String docType) async {
    // For image-only types, restrict to common image extensions.
    final isImageOnly = _imageOnlyDocTypes.contains(docType);

    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: isImageOnly ? FileType.image : FileType.any,
        withData: false,
        withReadStream: false,
      );
    } catch (_) {
      // File picker can throw on some platforms if the user aborts.
      return;
    }

    if (result == null || result.files.isEmpty || !mounted) return;

    final platformFile = result.files.first;

    // Guard: path must be available for file I/O.
    if (platformFile.path == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تعذّر قراءة مسار الملف. حاول مرة أخرى.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Client-side PDF rejection (redundant for image-only via FileType.image,
    // but kept as a safety net for any-type pickers and future doc types).
    final ext = platformFile.extension?.toLowerCase() ?? '';
    if (ext == 'pdf' && _imageOnlyDocTypes.contains(docType)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'نوع الملف PDF غير مقبول لهذا النوع من المستندات. '
              'يُرجى اختيار صورة بدلاً من ذلك.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Atomically replace any previously selected file — safe to call multiple
    // times before submission. Also clears any cached secureUrl.
    context.read<KycProvider>().setDocumentFile(docType, platformFile);
  }

  /// Uploads all locally-selected documents via the two-step flow, then
  /// submits KYC for review.
  Future<void> _submit() async {
    final provider = context.read<KycProvider>();

    final uploadedTypes =
        provider.kycStatus?.documents.map((d) => d.docType).toSet() ??
            <String>{};

    // Collect doc types that have either:
    //  a) a locally selected file not yet uploaded, OR
    //  b) a cached secureUrl waiting for document registration.
    final pending = <String>[];
    for (final docType in _docTypeLabels.keys) {
      final hasFile = provider.selectedFilePath(docType) != null;
      final hasSecureUrl = provider.hasSecureUrl(docType);
      final alreadyUploaded = uploadedTypes.contains(docType);
      if ((hasFile || hasSecureUrl) && !alreadyUploaded) {
        pending.add(docType);
      }
    }

    if (pending.isEmpty && uploadedTypes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('من فضلك ارفع المستندات المطلوبة أولاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Upload each pending document via the two-step flow.
      for (final docType in pending) {
        // uploadDocument() internally:
        //  1. Skips storage upload if secureUrl is already cached.
        //  2. Posts to /customers/documents with the secureUrl.
        //  3. On registration failure, keeps secureUrl in memory for retry.
        final errorMsg = await provider.uploadDocument(docType: docType);
        if (!mounted) return;
        if (errorMsg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
          );
          // Stop on first failure — user can fix and retry.
          return;
        }
      }

      if (!mounted) return;

      // Submit KYC for review after all documents are registered.
      final submitError = await provider.submitKyc();
      if (!mounted) return;
      if (submitError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(submitError), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KycProvider>(
      builder: (context, provider, _) {
        final uploadedTypes =
            provider.kycStatus?.documents.map((d) => d.docType).toSet() ??
                <String>{};

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight > 12
                      ? constraints.maxHeight - 12
                      : 0,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'رفع المستندات',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._docTypeLabels.entries.map((entry) {
                            final docType = entry.key;
                            final label = entry.value;
                            final isUploaded = uploadedTypes.contains(docType);
                            final selectedPath =
                                provider.selectedFilePath(docType);
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: KycUploadTile(
                                label: label,
                                isUploaded: isUploaded,
                                selectedPath: selectedPath,
                                isUploadingToStorage:
                                    provider.isUploadingToStorage(docType),
                                isRegisteringDocument:
                                    provider.isRegisteringDocument(docType),
                                // Already uploaded docs show as complete but
                                // can still be re-tapped to replace.
                                onTap: isUploaded
                                    ? null
                                    : () => _pickFile(docType),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A7A6E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: _isSubmitting
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.upload, color: Colors.white),
                            onPressed: _isSubmitting ? null : _submit,
                            label: const Text(
                              'تأكيد',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
