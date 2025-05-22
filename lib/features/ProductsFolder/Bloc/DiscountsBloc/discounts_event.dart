part of 'discounts_bloc.dart';

class DiscountsEvent {}

final class GetDiscountsDeailesEvent extends DiscountsEvent {
  final int? discountId;

  GetDiscountsDeailesEvent({required this.discountId});
}
