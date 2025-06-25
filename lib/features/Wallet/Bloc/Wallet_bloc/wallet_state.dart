part of 'wallet_bloc.dart';

class WalletState {}

final class WalletInitial extends WalletState {}

final class WalletLoading extends WalletState {}

final class WalletBalanceSuccess extends WalletState {
  final WalletModel wallet;

  WalletBalanceSuccess({required this.wallet});
}

final class TopUpWalletSuccess extends WalletState {}

final class WalletErrorState extends WalletState {
  final String message;

  WalletErrorState({required this.message});
}
