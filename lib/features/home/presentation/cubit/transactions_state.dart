part of 'transactions_cubit.dart';

abstract class TransactionsState {
  const TransactionsState();
}

class TransactionsInitial extends TransactionsState {}

class TransactionsLoading extends TransactionsState {}

class TransactionsLoaded extends TransactionsState {
  final TransactionDetailModel? dueInstallment;
  final List<TransactionDetailModel> historyItems;

  const TransactionsLoaded({
    this.dueInstallment,
    this.historyItems = const [],
  });
}

class TransactionsError extends TransactionsState {
  final String message;
  const TransactionsError(this.message);
}

