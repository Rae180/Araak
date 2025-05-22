part of 'room_details_bloc.dart';

class RoomDetailsState {}

final class RoomDetailsInitial extends RoomDetailsState {}

final class RoomDetailesLoading extends RoomDetailsState {}

final class RoomDetailsSuccess extends RoomDetailsState {
  final RoomDetailes room;

  RoomDetailsSuccess({required this.room});
}

final class RoomDetailesError extends RoomDetailsState {
  final String message;

  RoomDetailesError({required this.message});

}
