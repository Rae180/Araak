import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Wallet/Models/WalletModel.dart';

part 'wallet_event.dart';
part 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final BaseApiService client;
  WalletBloc({required this.client}) : super(WalletInitial()) {
    on<GetWalletBalanceEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.walletBal);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final wallet = WalletModel.fromJson(data);
        return wallet;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(WalletBalanceSuccess(wallet: responseData));
      });
    });

    on<TopUpWalletEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.postRequestAuth(url: ApiConstants.topup, jsonBody: {
          'token': event.token,
          'amount': event.amount,
          'description': event.descriptione,
          'payment_method': event.payment_method,
          'currency': event.currency
        });
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(TopUpWalletSuccess());
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return WalletErrorState(message: 'No internet');

      case NetworkErrorFailure:
        return WalletErrorState(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return WalletErrorState(
          message: 'Error',
        );
    }
  }
}
