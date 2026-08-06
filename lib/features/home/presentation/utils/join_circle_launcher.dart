import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/routes.dart';
import '../../../../core/services/services_locator.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../kyc/data/models/kyc_status_model.dart';
import '../../../kyc/data/services/kyc_service.dart';
import '../cubit/join_circle_cubit.dart';
import '../widgets/complete_profile_dialog.dart';

/// Centralized launcher for starting the Join Circle Flow across all screens
/// (Home screen, Available Circles screen, etc.).
///
/// Enforces profile completion check before allowing entry into the flow:
///  • If profile is complete (KYC verified) → launches Join Circle flow.
///  • If profile is incomplete → displays [CompleteProfileDialog].
abstract final class JoinCircleLauncher {
  static Future<void> startJoinFlow(
    BuildContext context, {
    required String circleId,
  }) async {
    // Show a minimal progress indicator overlay while validating profile completion
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
    );

    bool isProfileComplete = false;
    try {
      final kycService = getIt<KycService>();
      final data = await kycService.getKycStatus();
      final model = KycStatusModel.fromJson(data);
      isProfileComplete = (model.status == KycStatus.verified);
    } catch (_) {
      isProfileComplete = false;
    } finally {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop(); // dismiss progress overlay
      }
    }

    if (!context.mounted) return;

    if (isProfileComplete) {
      final cubit = getIt<JoinCircleCubit>();
      context.push(
        AppRoutes.circleDetailPath(circleId),
        extra: cubit,
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (dialogContext) => const CompleteProfileDialog(),
      );
    }
  }
}
