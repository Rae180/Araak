part of 'cart_bloc.dart';

class CartState {}

final class CartInitial extends CartState {}

final class CartLoading extends CartState {}

final class CartAddedSuccess extends CartState {}

final class GetCartItemsSuccess extends CartState {
  final CartItem item;

  GetCartItemsSuccess({required this.item});
}

final class RemoveItemFromCartSuccess extends CartState{}

final class CartError extends CartState {
  final String message;

  CartError({required this.message});
}
