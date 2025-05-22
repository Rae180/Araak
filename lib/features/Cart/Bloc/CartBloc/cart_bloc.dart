import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Cart/Models/CartItem.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final BaseApiService client;
  CartBloc({required this.client}) : super(CartInitial()) {
    on<AddRoomToCart>((event, emit) async {
      // emit(CartLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.addtocart,
            jsonBody: {'room_id': event.roomId, 'count': event.count});
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CartItem.fromJson(data);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(CartAddedSuccess());
        add(GetCartItemsEvent());
      });
    });

    on<AddItemToCart>(((event, emit) async {
      // emit(CartLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client
            .postRequestAuth(url: ApiConstants.addtocart, jsonBody: {
          'item_id': event.itemId,
          'count': event.count,
        });
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CartItem.fromJson(data);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(CartAddedSuccess());
        add(GetCartItemsEvent());
      });
    }));

    on<GetCartItemsEvent>((event, emit) async {
      emit(CartLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(url: ApiConstants.getcart);
        final Map<String, dynamic> data = jsonDecode(response.body);

        CartItem cart = CartItem.fromJson(data);
        return cart;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetCartItemsSuccess(item: responseData));
      });
    });

    on<RemoveFromCartEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            client.postRequestAuth(url: ApiConstants.removecart, jsonBody: {
          'item_id': event.itemId,
          'room_id': event.roomId,
          'customization_id': event.custId,
          'room_customization_id': event.roomCustId,
          'count': event.count
        });
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(RemoveItemFromCartSuccess());
        add(GetCartItemsEvent());
      });
    });
  }

  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return CartError(message: 'No internet');

      case NetworkErrorFailure:
        return CartError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return CartError(
          message: 'Error',
        );
    }
  }
}
