import 'package:flutter/material.dart';
import 'package:jameya_user/features/kyc/models/kyc_status_model.dart';
import 'package:provider/provider.dart';
import '../providers/kyc_provider.dart';
import 'kyc_screen.dart';

class KycGateScreen extends StatefulWidget {
  final Widget nextScreen;

  const KycGateScreen({super.key, required this.nextScreen});

  @override
  State<KycGateScreen> createState() => _KycGateScreenState();
}

class _KycGateScreenState extends State<KycGateScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<KycProvider>().loadStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<KycProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFFF7F7F7),
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final status = provider.kycStatus?.status;

        if (status == null || status != KycStatus.verified) {
          return const KycScreen();
        } else {
          return widget.nextScreen;
        }
      },
    );
  }
}
