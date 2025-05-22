part of 'fav_bloc.dart';

class FavState {}

final class FavInitial extends FavState {}

final class FavLoading extends FavState {}

final class FavSuccess extends FavState {
  final FavItem favs;

  FavSuccess({required this.favs});
}

final class LikeToggleSuccess extends FavState{}

final class AddedToFavsSuccess extends FavState{}

final class FavError extends FavState {
  final String message;

  FavError({required this.message});
}
