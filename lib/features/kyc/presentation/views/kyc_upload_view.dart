import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/kyc_provider.dart';
import '../widgets/kyc_upload_tile.dart';

/// Arabic labels for each known document type.
const _docTypeLabels = <String, String>{
  'NATIONAL_ID': 'الهوية الوطنية',
  'PASSPORT': 'جواز السفر',
  'PROOF_OF_INCOME': 'إثبات الدخل',
};

/// Document types that require image-only uploads and issue/expiry dates.
const _dateRequiredDocTypes = {
  'NATIONAL_ID',
  'PASSPORT',
  'CAR_LICENSE',
  'SYNDICATE_ID',
};

class KycUploadView extends StatefulWidget {
  const KycUploadView({super.key, required this.provider});

  final KycProvider provider;

  @override
  State<KycUploadView> createState() => _KycUploadViewState();
}

class _KycUploadViewState extends State<KycUploadView> {
  bool _isSubmitting = false;

  Future<void> _pickFile(String docType) async {
    final isImageOnly = _dateRequiredDocTypes.contains(docType);

    FilePickerResult? result;
    try {
      result = await FilePicker.pickFiles(
        allowMultiple: false,
        type: isImageOnly ? FileType.image : FileType.any,
        withData: false,
        withReadStream: false,
      );
    } catch (_) {
      return;
    }

    if (result == null || result.files.isEmpty || !mounted) return;

    final platformFile = result.files.first;

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

    final ext = platformFile.extension?.toLowerCase() ?? '';
    if (ext == 'pdf' && _dateRequiredDocTypes.contains(docType)) {
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

    context.read<KycProvider>().setDocumentFile(docType, platformFile);
  }

  Future<void> _pickIssueDate(String docType) async {
    final provider = context.read<KycProvider>();
    final initialDate = provider.issueDate(docType) ?? DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(DateTime.now()) ? DateTime.now() : initialDate,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      helpText: 'اختر تاريخ الإصدار',
    );

    if (picked != null && mounted) {
      provider.setIssueDate(docType, picked);
    }
  }

  Future<void> _pickExpiryDate(String docType) async {
    final provider = context.read<KycProvider>();
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final initialDate = provider.expiryDate(docType) ?? tomorrow;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(tomorrow) ? tomorrow : initialDate,
      firstDate: tomorrow,
      lastDate: DateTime(2050),
      helpText: 'اختر تاريخ الانتهاء',
    );

    if (picked != null && mounted) {
      provider.setExpiryDate(docType, picked);
    }
  }

  /// Uploads all locally-selected documents via the two-step flow, then
  /// submits KYC for review after strict validation.
  Future<void> _submit() async {
    final provider = context.read<KycProvider>();

    final uploadedTypes =
        provider.kycStatus?.documents.map((d) => d.docType).toSet() ??
        <String>{};

    // ── Bug #1 Validation: Ensure mandatory documents exist ───────────────
    final hasIdentity = uploadedTypes.contains('NATIONAL_ID') ||
        uploadedTypes.contains('PASSPORT') ||
        provider.selectedFilePath('NATIONAL_ID') != null ||
        provider.selectedFilePath('PASSPORT') != null;

    final hasProofOfIncome = uploadedTypes.contains('PROOF_OF_INCOME') ||
        provider.selectedFilePath('PROOF_OF_INCOME') != null;

    if (!hasIdentity && !hasProofOfIncome) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يُرجى إرفاق الهوية الوطنية/جواز السفر وإثبات الدخل قبل التأكيد'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (!hasIdentity) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يُرجى إرفاق الهوية الوطنية أو جواز السفر'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (!hasProofOfIncome) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A proof of income document is required before submitting (PROOF_OF_INCOME).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Collect pending docTypes
    final pending = <String>[];
    for (final docType in _docTypeLabels.keys) {
      final hasFile = provider.selectedFilePath(docType) != null;
      final hasSecureUrl = provider.hasSecureUrl(docType);
      final alreadyUploaded = uploadedTypes.contains(docType);
      if ((hasFile || hasSecureUrl) && !alreadyUploaded) {
        pending.add(docType);
      }
    }

    // ── Bug #2 Validation: Ensure date fields criteria are met ─────────────
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final docType in pending) {
      if (_dateRequiredDocTypes.contains(docType)) {
        final issue = provider.issueDate(docType);
        final expiry = provider.expiryDate(docType);
        final docLabel = _docTypeLabels[docType] ?? docType;

        if (issue == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('يُرجى تحديد تاريخ الإصدار لـ $docLabel'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final issueDay = DateTime(issue.year, issue.month, issue.day);
        if (issueDay.isAfter(today)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تاريخ الإصدار لـ $docLabel يجب أن يكون في الماضي أو اليوم'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        if (expiry == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('يُرجى تحديد تاريخ الانتهاء لـ $docLabel'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
        if (!expiryDay.isAfter(today)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تاريخ الانتهاء لـ $docLabel يجب أن يكون في المستقبل'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
      }
    }

    setState(() => _isSubmitting = true);

    try {
      // Upload each pending document via the two-step flow.
      for (final docType in pending) {
        final errorMsg = await provider.uploadDocument(docType: docType);
        if (!mounted) return;
        if (errorMsg != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMsg), backgroundColor: Colors.red),
          );
          return;
        }
      }

      if (!mounted) return;

      // Submit KYC for review ONLY after all mandatory documents are uploaded and registered.
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
                            final selectedPath = provider.selectedFilePath(
                              docType,
                            );
                            final requiresDates = _dateRequiredDocTypes.contains(docType);

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: KycUploadTile(
                                label: label,
                                isUploaded: isUploaded,
                                selectedPath: selectedPath,
                                isUploadingToStorage: provider
                                    .isUploadingToStorage(docType),
                                isRegisteringDocument: provider
                                    .isRegisteringDocument(docType),
                                requiresDates: requiresDates,
                                issueDate: provider.issueDate(docType),
                                expiryDate: provider.expiryDate(docType),
                                onPickIssueDate: () => _pickIssueDate(docType),
                                onPickExpiryDate: () => _pickExpiryDate(docType),
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
