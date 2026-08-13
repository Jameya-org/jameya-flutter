part of 'payment_details_cubit.dart';

abstract class PaymentDetailsState {
  const PaymentDetailsState();
}

/// Initial / editable — user can tap "ادفع الآن"
class PaymentDetailsReady extends PaymentDetailsState {
  final TransactionDetailModel? model;
  const PaymentDetailsReady({this.model});
}

/// Payment is in flight — show loading overlay
class PaymentDetailsProcessing extends PaymentDetailsState {
  final TransactionDetailModel? model;
  const PaymentDetailsProcessing({this.model});
}

/// Terminal result — paid ✅ or failed ❌  or pending ⏳
class PaymentDetailsResult extends PaymentDetailsState {
  final TransactionDetailModel model;
  const PaymentDetailsResult({required this.model});
}
