part of 'placing_order_bloc.dart';

class PlacingOrderState {}

final class PlacingOrderInitial extends PlacingOrderState {}

final class PlacingOrderLoading extends PlacingOrderState {}

final class LocationSendSuccess extends PlacingOrderState {
  final NearBranch nearBranch;

  LocationSendSuccess({required this.nearBranch});
}

final class DeliveryPriceSuccessState extends PlacingOrderState {
  final num? deliveryPrice;

  DeliveryPriceSuccessState({required this.deliveryPrice});
}

final class PlacingAnOrderWithDeliverySuccess extends PlacingOrderState{}

final class PlacingOrderError extends PlacingOrderState {
  final String message;

  PlacingOrderError({required this.message});
}
