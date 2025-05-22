part of 'item_detailes_bloc.dart';

class ItemDetailesEvent {}

final class GetItemDetailesEvent extends ItemDetailesEvent {
  final int? itemId;

  GetItemDetailesEvent({required this.itemId});
}
