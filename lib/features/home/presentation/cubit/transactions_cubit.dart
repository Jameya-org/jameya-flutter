import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../payment/data/models/transaction_detail_model.dart';
import '../../../payment/data/services/payment_service.dart';

part 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  final PaymentService paymentService;

  TransactionsCubit(this.paymentService) : super(TransactionsInitial());

  /// Load unified customer installments and transactions history from API
  Future<void> loadTransactions() async {
    emit(TransactionsLoading());
    try {
      final results = await Future.wait([
        paymentService.getInstallments().catchError((_) => <String, dynamic>{}),
        paymentService.getInstallmentsHistory().catchError((_) => <Map<String, dynamic>>[]),
      ]);

      final installmentsData = results[0] as Map<String, dynamic>;
      final historyRawList = results[1] as List<Map<String, dynamic>>;

      // ── Parse Next Due Installment ──────────────────────────────
      TransactionDetailModel? dueInstallment;
      if (installmentsData['nextDue'] != null && installmentsData['nextDue'] is Map) {
        dueInstallment = TransactionDetailModel.fromJson(
          Map<String, dynamic>.from(installmentsData['nextDue'] as Map),
        );
      } else if (installmentsData['nextInstallment'] != null && installmentsData['nextInstallment'] is Map) {
        dueInstallment = TransactionDetailModel.fromJson(
          Map<String, dynamic>.from(installmentsData['nextInstallment'] as Map),
        );
      } else if (installmentsData['schedule'] is List && (installmentsData['schedule'] as List).isNotEmpty) {
        final schedule = installmentsData['schedule'] as List;
        final pendingItem = schedule.firstWhere(
          (e) => e is Map && (e['status'] == 'DUE' || e['status'] == 'pending' || e['status'] == 'late'),
          orElse: () => null,
        );
        if (pendingItem != null && pendingItem is Map) {
          dueInstallment = TransactionDetailModel.fromJson(Map<String, dynamic>.from(pendingItem));
        }
      }

      // ── Parse History Items ─────────────────────────────────────
      final historyItems = historyRawList
          .map((item) => TransactionDetailModel.fromJson(item))
          .toList();

      emit(TransactionsLoaded(
        dueInstallment: dueInstallment,
        historyItems: historyItems,
      ));
    } catch (e) {
      emit(TransactionsError('حدث خطأ في تحميل سجل المعاملات'));
    }
  }
}

