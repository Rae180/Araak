part of 'item_detailes_bloc.dart';

class ItemDetailesState {}

final class ItemDetailesInitial extends ItemDetailesState {}

final class ItemDetailesLoading extends ItemDetailesState {}

final class ItemDetailesSuccess extends ItemDetailesState {
  final ItemDetails item;

  ItemDetailesSuccess({required this.item});
}

final class ItemDetailesError extends ItemDetailesState {
  final String message;

  ItemDetailesError({required this.message});
}
