part of 'fav_bloc.dart';

class FavEvent {}

final class GetFavs extends FavEvent {}

final class LikeToggleEvent extends FavEvent {
  final int? roomId;
  final int? itemId;

  LikeToggleEvent(this.roomId, this.itemId);
}

final class AddToFavEvent extends FavEvent {
  final int? roomId;
  final int? itemId;

  AddToFavEvent(this.roomId, this.itemId);
}

final class AddAllToFavEvent extends FavEvent {
  final List<int?> RoomsId;
  final List<int?> ItemsId;

  AddAllToFavEvent({required this.RoomsId, required this.ItemsId});
}
