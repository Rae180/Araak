part of 'placing_order_bloc.dart';

class PlacingOrderEvent {}

final class GetNearestBranchEvent extends PlacingOrderEvent {
  final double longitue;
  final double latitude;

  GetNearestBranchEvent({required this.longitue, required this.latitude});
}

final class GetDeliveryPriceEvent extends PlacingOrderEvent {
  final String? address;
  final num? Longitude;
  final num? Latitude;

  GetDeliveryPriceEvent(
      {required this.address, required this.Longitude, required this.Latitude});
}

final class PlacingAnOrderWithDeliveryEvent extends PlacingOrderEvent {
  final num? longitude;
  final num? latitude;
  final String? address;

  PlacingAnOrderWithDeliveryEvent(
      {required this.longitude, required this.latitude, required this.address});
}

final class PlacingOrderPickupEvent extends PlacingOrderEvent {
  final num latitude;
  final num longitude;

  PlacingOrderPickupEvent({required this.latitude, required this.longitude});
}
