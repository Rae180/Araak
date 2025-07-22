part of 'wallet_bloc.dart';

class WalletEvent {}

final class GetWalletBalanceEvent extends WalletEvent {}

final class TopUpWalletEvent extends WalletEvent {
  final String? token;
  final num? amount;
  final String? descriptione;
  final String? payment_method;
  final String? currency;

  TopUpWalletEvent({required this.token, required this.amount, required this.descriptione, required this.payment_method, required this.currency});
}

final class GetTransactionsEvent extends WalletEvent{}
