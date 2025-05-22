part of 'rooms_by_category_bloc.dart';

class RoomsByCategoryState {}

final class RoomsByCategoryInitial extends RoomsByCategoryState {}

final class RoomsByCategoryLoading extends RoomsByCategoryState {}

final class RoomsByCategorySuccess extends RoomsByCategoryState {
  final RoomsByCategoryModel rooms;

  RoomsByCategorySuccess({required this.rooms});
}

final class GetAllFurSuccess extends RoomsByCategoryState {
  final AllFur furnitures;

  GetAllFurSuccess({required this.furnitures});
}

final class RoomsByCategoryError extends RoomsByCategoryState {
  final String message;

  RoomsByCategoryError({required this.message});
}
