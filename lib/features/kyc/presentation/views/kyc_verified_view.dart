import 'package:flutter/material.dart';

import '../providers/kyc_provider.dart';
import '../widgets/kyc_info_row.dart';

class KycVerifiedView extends StatelessWidget {
  final KycProvider provider;

  const KycVerifiedView({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    final kyc = provider.kycStatus!;
    final identity = kyc.identityProfile;
    final eligibility = kyc.latestEligibility;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Container(
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
            // Legal name from the top-level response field
            KycInfoRow(label: 'الاسم الكامل', value: kyc.legalName ?? '-'),
            // National ID from identity profile
            if (identity != null)
              KycInfoRow(
                label: 'رقم الهوية',
                value: identity.nationalIdNumber ?? '-',
              ),
            // Eligibility status
            if (eligibility != null && eligibility.status != null)
              KycInfoRow(label: 'حالة الأهلية', value: eligibility.status!),
            // Uploaded documents summary
            if (kyc.documents.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'المستندات المرفوعة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A7A6E),
                  ),
                ),
              ),
              ...kyc.documents.map(
                (doc) => KycInfoRow(
                  label: doc.docType,
                  value: doc.status ?? '-',
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
