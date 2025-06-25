import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/home/Models/AllFur.dart';
import 'package:start/features/home/Models/RoomsByCategoryModel.dart';

part 'rooms_by_category_event.dart';
part 'rooms_by_category_state.dart';

class RoomsByCategoryBloc
    extends Bloc<RoomsByCategoryEvent, RoomsByCategoryState> {
  final BaseApiService client;
  RoomsByCategoryBloc({required this.client})
      : super(RoomsByCategoryInitial()) {
    on<GetRoomsByCategory>((event, emit) async {
      emit(RoomsByCategoryLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequest(
            url: ApiConstants.getRoomsbyCat + event.categoryId.toString());
        RoomsByCategoryModel rooms = RoomsByCategoryModel.fromJson(response);
        return rooms;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(RoomsByCategorySuccess(rooms: responseData));
      });
    });

    on<GetAllFurEvent>(((event, emit) async {
      emit(RoomsByCategoryLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequest(url: ApiConstants.showAllFur);
        final furr = AllFur.fromJson(response);
        return furr;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(GetAllFurSuccess(furnitures: responseData));
      });
    }));
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return RoomsByCategoryError(message: 'No internet');

      case NetworkErrorFailure:
        return RoomsByCategoryError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return RoomsByCategoryError(
          message: 'Error',
        );
    }
  }
}
