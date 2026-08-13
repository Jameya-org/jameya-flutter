import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/models/kyc_status_model.dart';
import '../providers/kyc_provider.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KycProvider>().loadStatus();
    });
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFile(String docType) async {
    final provider = context.read<KycProvider>(); // capture before async gap
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;
    if (!mounted) return;
    
    if (docType == 'NATIONAL_ID') {
      provider.setNationalIdFile(File(picked.path));
    } else {
      provider.setIncomeProofFile(File(picked.path));
    }
  }

  Future<void> _submitAll() async {
    final provider = context.read<KycProvider>();
    setState(() => _isSubmitting = true);

    try {
      // 1. Upload National ID if selected and not uploaded
      if (provider.selectedFilePath('NATIONAL_ID') != null) {
        final err = await provider.uploadDocument(docType: 'NATIONAL_ID');
        if (err != null) {
          _showError(err);
          return;
        }
      }

      // 2. Upload Income Proof if selected and not uploaded
      if (provider.selectedFilePath('PROOF_OF_INCOME') != null) {
        final err = await provider.uploadDocument(docType: 'PROOF_OF_INCOME');
        if (err != null) {
          _showError(err);
          return;
        }
      }

      // 3. Submit KYC review
      final submitErr = await provider.submitKyc();
      if (!mounted) return;
      if (submitErr != null) {
        _showError(submitErr);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال المستندات للمراجعة بنجاح ✅'),
            backgroundColor: Color(0xFF1A7A6E),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'توثيق الحساب',
            style: TextStyle(
              color: Color(0xFF1A7A6E),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF1A7A6E),
              size: 18,
            ),
            onPressed: () => context.pop(),
          ),
        ),
        body: Consumer<KycProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.error != null && provider.kycStatus == null) {
              return _buildLoadError(provider);
            }

            final status = provider.status;

            switch (status) {
              case KycStatus.verified:
                return _buildVerified(provider);
              case KycStatus.pendingReview:
                return _buildPending(provider);
              case KycStatus.rejected:
              case KycStatus.notVerified:
                return _buildUploadOrNotVerified(provider);
            }
          },
        ),
      ),
    );
  }

  // ======== حالة: خطأ في الاتصال / التحميل ========
  Widget _buildLoadError(KycProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              provider.error ?? 'حدث خطأ في تحميل حالة التوثيق',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red, fontSize: 14),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A7A6E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => context.read<KycProvider>().loadStatus(),
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======== حالة: الهوية موثقة ========
  Widget _buildVerified(KycProvider provider) {
    final kyc = provider.kycStatus;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD6F5EF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF1A7A6E),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'الهوية موثقة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A7A6E),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'تم التحقق من هويتك بنجاح.\nيمكنك الآن الاستفادة من جميع ميزات التطبيق.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                _infoRow('الاسم الكامل', kyc?.fullName ?? '-'),
                _infoRow('رقم الهوية', kyc?.idNumber ?? '-'),
                _infoRow('تاريخ التوثيق', kyc?.verifiedAt ?? '-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ======== حالة: قيد المراجعة ========
  Widget _buildPending(KycProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF3CD),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'قيد المراجعة',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A7A6E),
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'تم استلام مستنداتك وهي قيد المراجعة من قبل فريقنا.\nسيتم إشعارك خلال 24-48 ساعة.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(provider.kycStatus?.submittedAt ?? '-'),
                          const Text('تم الإرسال:'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1-2 يوم عمل'),
                          Text('الوقت المتوقع للمراجعة:'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A7A6E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.pop(),
              child: const Text(
                'تم',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ======== حالة: مش موثق / رفع مستندات ========
  Widget _buildUploadOrNotVerified(KycProvider provider) {
    final nationalIdPath = provider.selectedFilePath('NATIONAL_ID');
    final incomeProofPath = provider.selectedFilePath('PROOF_OF_INCOME');
    final isNationalUploaded = provider.kycStatus?.nationalIdUploaded ?? false;
    final isIncomeUploaded = provider.kycStatus?.incomeProofUploaded ?? false;

    final isUploading = provider.isUploading('NATIONAL_ID') ||
        provider.isUploading('PROOF_OF_INCOME') ||
        _isSubmitting;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _uploadTile(
                  label: 'الهوية الوطنية',
                  filePath: nationalIdPath,
                  isUploaded: isNationalUploaded,
                  isLoading: provider.isUploading('NATIONAL_ID'),
                  onTap: () => _pickFile('NATIONAL_ID'),
                ),
                const SizedBox(height: 12),
                _uploadTile(
                  label: 'إثبات مرتب',
                  filePath: incomeProofPath,
                  isUploaded: isIncomeUploaded,
                  isLoading: provider.isUploading('PROOF_OF_INCOME'),
                  onTap: () => _pickFile('PROOF_OF_INCOME'),
                ),
              ],
            ),
          ),
          const Spacer(),
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
              icon: isUploading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.upload, color: Colors.white),
              onPressed: isUploading ? null : _submitAll,
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
    );
  }

  Widget _uploadTile({
    required String label,
    required String? filePath,
    required bool isUploaded,
    required bool isLoading,
    required VoidCallback onTap,
  }) {
    final hasFile = filePath != null || isUploaded;

    String subtitle = 'اضغط لرفع الملف';
    if (isLoading) {
      subtitle = 'جاري الرفع...';
    } else if (isUploaded) {
      subtitle = 'تم رفع المستند في الخادم ✅';
    } else if (filePath != null) {
      final fileName = filePath.split(Platform.pathSeparator).last;
      subtitle = 'تم اختيار: $fileName';
    }

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: hasFile
                ? const Color(0xFF1A7A6E)
                : Colors.grey.shade300,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(12),
          color: hasFile ? const Color(0xFFE8F6F3) : Colors.grey.shade50,
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFFD6EAF8),
              child: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      hasFile ? Icons.check : Icons.person_outline,
                      color: const Color(0xFF1A7A6E),
                    ),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: hasFile ? const Color(0xFF1A7A6E) : Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
