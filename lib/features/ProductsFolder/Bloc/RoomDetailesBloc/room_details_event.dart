part of 'room_details_bloc.dart';

class RoomDetailsEvent {}

final class GetRoomDetailes extends RoomDetailsEvent {
  final int? roomId;

  GetRoomDetailes({required this.roomId});
}
