import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../providers/kyc_provider.dart';
import '../widgets/kyc_upload_tile.dart';

class KycUploadView extends StatefulWidget {
  final KycProvider provider;

  const KycUploadView({super.key, required this.provider});

  @override
  State<KycUploadView> createState() => _KycUploadViewState();
}

class _KycUploadViewState extends State<KycUploadView> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile(bool isNationalId) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    final provider = context.read<KycProvider>();
    if (isNationalId) {
      provider.setNationalIdFile(File(picked.path));
    } else {
      provider.setIncomeProofFile(File(picked.path));
    }
  }

  Future<void> _submit() async {
    final provider = context.read<KycProvider>();
    final success = await provider.submitDocuments();
    if (!mounted) return;
    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.error ?? 'فشل إرسال المستندات'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      KycUploadTile(
                        label: 'الهوية الوطنية',
                        file: widget.provider.nationalIdFile,
                        onTap: () => _pickFile(true),
                      ),
                      const SizedBox(height: 12),
                      KycUploadTile(
                        label: 'إثبات مرتب',
                        file: widget.provider.incomeProofFile,
                        onTap: () => _pickFile(false),
                      ),
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
                        icon: widget.provider.isSubmitting
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.upload, color: Colors.white),
                        onPressed: widget.provider.isSubmitting
                            ? null
                            : _submit,
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
  }
}
