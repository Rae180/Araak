part of 'orders_bloc.dart';

class OrdersState {}

final class OrdersInitial extends OrdersState {}

final class OrdersLoading extends OrdersState {}

final class AllOrdersSuucess extends OrdersState {
  final AllOrders orders;

  AllOrdersSuucess({required this.orders});
}

final class OrdersError extends OrdersState {
  final String message;

  OrdersError({required this.message});
}
