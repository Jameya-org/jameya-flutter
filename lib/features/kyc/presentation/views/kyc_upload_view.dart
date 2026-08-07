import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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

class KycUploadView extends StatefulWidget {
  final KycProvider provider;

  const KycUploadView({super.key, required this.provider});

  @override
  State<KycUploadView> createState() => _KycUploadViewState();
}

class _KycUploadViewState extends State<KycUploadView> {
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;

  /// Picks an image for [docType] and stores it in the provider.
  ///
  /// BUG FIX: Calling this multiple times simply overwrites the previous
  /// selection via [KycProvider.setDocumentFile]. The map entry is replaced
  /// atomically — no exception, no stale reference.
  Future<void> _pickFile(String docType) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;

    // Atomically replace any previously selected file — safe to call multiple
    // times before submission.
    context.read<KycProvider>().setDocumentFile(docType, picked.path);
  }

  /// Uploads all locally-selected documents, then submits KYC for review.
  Future<void> _submit() async {
    final provider = context.read<KycProvider>();

    final uploadedTypes =
        provider.kycStatus?.documents.map((d) => d.docType).toSet() ??
            <String>{};

    // Collect files selected locally that haven't been uploaded to the backend
    // yet.
    final pending = <String, String>{};
    for (final docType in _docTypeLabels.keys) {
      final path = provider.selectedFilePath(docType);
      if (path != null && path.isNotEmpty && !uploadedTypes.contains(docType)) {
        pending[docType] = path;
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
      // Upload each pending file
      for (final entry in pending.entries) {
        final errorMsg = await provider.uploadDocument(
          docType: entry.key,
          // encryptedObjectRef is the local file path reference sent to
          // the backend as the object reference for this document.
          encryptedObjectRef: entry.value,
          issueDate: '',
          expiryDate: '',
        );
        if (!mounted) return;
        if (errorMsg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
          );
          return;
        }
      }

      // Submit KYC for review
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
                                isUploading: provider.isUploading(docType),
                                // Already uploaded docs show as complete
                                // but can't be re-tapped.
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
