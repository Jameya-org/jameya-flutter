import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/kyc_status_model.dart';
import '../providers/kyc_provider.dart';
import 'kyc_pending_view.dart';
import 'kyc_upload_view.dart';
import 'kyc_verified_view.dart';

class KycVerificationView extends StatefulWidget {
  const KycVerificationView({super.key});

  @override
  State<KycVerificationView> createState() => _KycVerificationViewState();
}

class _KycVerificationViewState extends State<KycVerificationView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<KycProvider>().loadStatus();
    });
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
          title: const Text(
            'توثيق الحساب',
            style: TextStyle(color: Color(0xFF1A7A6E), fontSize: 16),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.chevron_left,
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

            final status = provider.kycStatus?.status ?? KycStatus.notVerified;

            switch (status) {
              case KycStatus.verified:
                return KycVerifiedView(provider: provider);
              case KycStatus.pendingReview:
                return KycPendingView(provider: provider);
              case KycStatus.rejected:
              case KycStatus.notVerified:
                return KycUploadView(provider: provider);
            }
          },
        ),
      ),
    );
  }
}
