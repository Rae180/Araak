import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import '../../Models/AllOrders.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final BaseApiService client;
  OrdersBloc({required this.client}) : super(OrdersInitial()) {
    on<GetAllOrdersEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.allorders);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final orders = AllOrders.fromJson(data);
        return orders;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AllOrdersSuucess(orders: responseData));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return OrdersError(message: 'No internet');

      case NetworkErrorFailure:
        return OrdersError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return OrdersError(
          message: 'Error',
        );
    }
  }
}
