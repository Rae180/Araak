part of 'discounts_bloc.dart';

class DiscountsState {}

final class DiscountsInitial extends DiscountsState {}

final class DiscountsLoading extends DiscountsState {}

final class DiscountsDetailesSuccess extends DiscountsState {
  final DiscountModel discount;

  DiscountsDetailesSuccess({required this.discount});
}

final class DiscountsError extends DiscountsState {
  final String message;

  DiscountsError({required this.message});
}
