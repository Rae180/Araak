import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Favoritse/Models/FavItem.dart';

part 'fav_event.dart';
part 'fav_state.dart';

class FavBloc extends Bloc<FavEvent, FavState> {
  final BaseApiService client;
  FavBloc({required this.client}) : super(FavInitial()) {
    on<GetFavs>((event, emit) async {
      emit(FavLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.getfavos);
        final Map<String, dynamic> data = jsonDecode(response.body);
        final FavItem favs = FavItem.fromJson(data);
        return favs;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(FavSuccess(favs: responseData));
      });
    });

    on<LikeToggleEvent>(
      ((event, emit) async {
        emit(FavLoading());
        print('Liking from Bloc...');
        final result = await BaseRepo.repoRequest(request: () async {
          return await client
              .postRequestAuth(url: ApiConstants.liketog, jsonBody: {
            'item_id': event.itemId,
            'room_id': event.roomId,
          });
        });
        result.fold((f) {
          emit(_mapFailureToState(f));
        }, (responseData) {
          emit(LikeToggleSuccess());
          add(GetFavs());
        });
      }),
    );

    on<AddToFavEvent>(
      ((event, emit) async {
        emit(FavLoading());
        final result = await BaseRepo.repoRequest(request: () async {
          return await client
              .postRequestAuth(url: ApiConstants.addtofav, jsonBody: {
            'item_id': event.itemId,
            'room_id': event.roomId,
          });
        });
        result.fold((f) {
          emit(_mapFailureToState(f));
        }, (responseData) {
          emit(AddedToFavsSuccess());
          add(GetFavs());
        });
      }),
    );

    on<AddAllToFavEvent>((event, emit) async {
      emit(FavLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final data = await client
            .postRequestAuth(url: ApiConstants.addalltofav, jsonBody: {
          'room_ids': event.RoomsId,
          'item_ids': event.ItemsId,
        });
        return data;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(AddedToFavsSuccess());
        add(GetFavs());
      });
    });
  }

  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return FavError(message: 'No internet');

      case NetworkErrorFailure:
        return FavError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return FavError(
          message: 'Error',
        );
    }
  }
}
