// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/home/Models/RecommendModel.dart';

part 'recommend_event.dart';
part 'recommend_state.dart';

class RecommendBloc extends Bloc<RecommendEvent, RecommendState> {
  final BaseApiService client;
  RecommendBloc({
    required this.client,
  }) : super(RecommendInitial()) {
    on<GetRecommends>((event, emit) async {
      emit(RecomendLoading());
      final result = await BaseRepo.repoRequest(request: () async {
        final response =
            await client.getRequestAuth(url: ApiConstants.getRecom);
        final Map<String, dynamic> data = jsonDecode(response.body);
        RecommendModel recommend = RecommendModel.fromJson(data);
        return recommend;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (resonseData) {
        emit(RecomendSuccess(recommend: resonseData));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return RecommendError(message: 'No internet');

      case NetworkErrorFailure:
        return RecommendError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return RecommendError(
          message: 'Error',
        );
    }
  }
}
