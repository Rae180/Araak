part of 'cart_bloc.dart';

class CartEvent {}

final class AddRoomToCart extends CartEvent {
  final int roomId;
  final int count;

  AddRoomToCart({required this.roomId, required this.count});
}

final class AddItemToCart extends CartEvent {
  final int itemId;
  final int count;

  AddItemToCart({required this.itemId, required this.count});
}

final class GetCartItemsEvent extends CartEvent {}

final class RemoveFromCartEvent extends CartEvent {
  final int? roomId;
  final int? itemId;
  final int? custId;
  final int? roomCustId;
  final int? count;

  RemoveFromCartEvent({required this.roomId, required this.itemId, required this.custId, required this.roomCustId, required this.count});
}
