import 'dart:io';

void main() {
  // Move KYC screens
  File('d:/AppInFlutter/jameya/lib/features/kyc/data/services/kyc_screen.dart')
      .renameSync('d:/AppInFlutter/jameya/lib/features/kyc/presentation/views/kyc_screen.dart');
  File('d:/AppInFlutter/jameya/lib/features/kyc/data/services/kyc_gate_screen.dart')
      .renameSync('d:/AppInFlutter/jameya/lib/features/kyc/presentation/views/kyc_gate_screen.dart');
  
  // Delete old KYC views
  _tryDelete('d:/AppInFlutter/jameya/lib/features/kyc/presentation/views/kyc_upload_view.dart');
  _tryDelete('d:/AppInFlutter/jameya/lib/features/kyc/presentation/views/kyc_verification_view.dart');
  _tryDelete('d:/AppInFlutter/jameya/lib/features/kyc/presentation/views/kyc_verified_view.dart');
  _tryDelete('d:/AppInFlutter/jameya/lib/features/kyc/presentation/views/kyc_pending_view.dart');

  // Delete old Payment views
  _tryDelete('d:/AppInFlutter/jameya/lib/features/payment/presentation/views/add_card_view.dart');
  _tryDelete('d:/AppInFlutter/jameya/lib/features/payment/presentation/views/payment_methods_view.dart');

  // Delete old Profile views
  _tryDelete('d:/AppInFlutter/jameya/lib/features/profile/presentation/views/profile_view.dart');
  _tryDelete('d:/AppInFlutter/jameya/lib/features/profile/presentation/views/profile_details_view.dart');
}

void _tryDelete(String path) {
  try {
    final file = File(path);
    if (file.existsSync()) {
      file.deleteSync();
    }
  } catch (e) {
    print('Failed to delete $path: $e');
  }
}
