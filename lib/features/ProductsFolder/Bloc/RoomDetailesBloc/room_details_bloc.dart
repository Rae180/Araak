import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/ProductsFolder/Models/RoomDetails.dart';

part 'room_details_event.dart';
part 'room_details_state.dart';

class RoomDetailsBloc extends Bloc<RoomDetailsEvent, RoomDetailsState> {
  final BaseApiService client;
  RoomDetailsBloc({required this.client}) : super(RoomDetailsInitial()) {
    on<GetRoomDetailes>((event, emit) async {
      emit(RoomDetailesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(
            url: ApiConstants.getRoomDet + event.roomId.toString());
        final Map<String, dynamic> data = jsonDecode(response.body);
        RoomDetailes room = RoomDetailes.fromJson(data);
        return room;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(RoomDetailsSuccess(room: responseData));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return RoomDetailesError(message: 'No internet');

      case NetworkErrorFailure:
        return RoomDetailesError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return RoomDetailesError(
          message: 'Error',
        );
    }
  }
}
