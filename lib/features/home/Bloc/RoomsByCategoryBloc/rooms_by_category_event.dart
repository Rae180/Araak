part of 'rooms_by_category_bloc.dart';

class RoomsByCategoryEvent {}

final class GetRoomsByCategory extends RoomsByCategoryEvent {
  final int categoryId;

  GetRoomsByCategory({required this.categoryId});
}
