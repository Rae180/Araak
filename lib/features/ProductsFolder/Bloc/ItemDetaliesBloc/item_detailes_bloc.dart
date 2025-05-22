import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/ProductsFolder/Models/ItemDetailes.dart';

part 'item_detailes_event.dart';
part 'item_detailes_state.dart';

class ItemDetailesBloc extends Bloc<ItemDetailesEvent, ItemDetailesState> {
  final BaseApiService client;
  ItemDetailesBloc({required this.client}) : super(ItemDetailesInitial()) {
    on<GetItemDetailesEvent>((event, emit) async {
      emit(ItemDetailesLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(
            url: ApiConstants.itemdet + event.itemId.toString());
        final Map<String, dynamic> data = jsonDecode(response.body);
        final ItemDetails item = ItemDetails.fromJson(data);
        return item;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(ItemDetailesSuccess(item: responseData));
      });
    });
  }

  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return ItemDetailesError(message: 'No internet');

      case NetworkErrorFailure:
        return ItemDetailesError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return ItemDetailesError(
          message: 'Error',
        );
    }
  }
}
