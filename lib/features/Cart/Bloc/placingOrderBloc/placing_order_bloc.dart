import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Cart/Models/NearBranch.dart';
import 'package:start/features/Cart/Models/PlacingOrderSuccess.dart';

part 'placing_order_event.dart';
part 'placing_order_state.dart';

class PlacingOrderBloc extends Bloc<PlacingOrderEvent, PlacingOrderState> {
  final BaseApiService client;
  PlacingOrderBloc({required this.client}) : super(PlacingOrderInitial()) {
    on<GetNearestBranchEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client
            .postRequestAuth(url: ApiConstants.nearBranch, jsonBody: {
          'latitude': event.latitude,
          'longitude': event.longitue,
        });

        final Map<String, dynamic> data = jsonDecode(response.body);
        final order = NearBranch.fromJson(data);
        return order;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        print('success bro');
        emit(LocationSendSuccess(nearBranch: responseData));
      });
    });

    on<GetDeliveryPriceEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.postRequestAuth(url: ApiConstants.delprice, jsonBody: {
          'address': event.address,
          'latitude': event.Latitude,
          'longitude': event.Longitude,
        });
        final Map<String, dynamic> data = jsonDecode(response.body);
        final price = data['delivery_price'];
        return price;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DeliveryPriceSuccessState(deliveryPrice: responseData));
      });
    }));

    on<PlacingAnOrderWithDeliveryEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client
            .postRequestAuth(url: ApiConstants.confirmcartdel, jsonBody: {
          "want_delivery": "yes",
          "latitude": event.latitude,
          "longitude": event.longitude,
          "address": event.address,
          "recive_date": ""
        });
        return response;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(PlacingAnOrderWithDeliverySuccess());
      });
    });
    on<PlacingOrderPickupEvent>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.postRequestAuth(
            url: ApiConstants.confirmcart,
            jsonBody: {
              "want_delivery": "no",
              "latitude": event.latitude,
              "longitude": event.longitude
            });
        final Map<String, dynamic> data = jsonDecode(response);
        final placingorder = PlacingOrderResponse.fromJson(data);
        return placingorder;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(PlacingAnOrderPickupSuccess(response: responseData));
      });
    }));
  }

  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return PlacingOrderError(message: 'No internet');

      case NetworkErrorFailure:
        return PlacingOrderError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return PlacingOrderError(
          message: 'Error',
        );
    }
  }
}
