import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Searching/Models/SearchRes.dart';

part 'search_res_event.dart';
part 'search_res_state.dart';

class SearchResBloc extends Bloc<SearchResEvent, SearchResState> {
  final BaseApiService client;
  SearchResBloc({required this.client}) : super(SearchResInitial()) {
    on<GetSearchResultsEvent>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequest(
            url: ApiConstants.searchQuery + event.query);

        final SearchResult searchResult = SearchResult.fromJson(response);
        return searchResult;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(SearchSuccess(results: responseData));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return SearchError(message: 'No internet');

      case NetworkErrorFailure:
        return SearchError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return SearchError(
          message: 'Error',
        );
    }
  }
}
