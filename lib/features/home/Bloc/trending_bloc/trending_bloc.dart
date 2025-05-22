// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';

import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/home/Models/Trending.dart';

part 'trending_event.dart';
part 'trending_state.dart';

class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final BaseApiService client;
  TrendingBloc({
    required this.client,
  }) : super(TrendingInitial()) {
    on<GetTrendings>((event, emit) async {
      emit(TrendingLoading());
      final data = await BaseRepo.repoRequest(request: () async {
        final data = await client.getRequest(url: ApiConstants.getTrend);
        Trending trending = Trending.fromJson(data);
        return trending;
      });
      data.fold((f) {
        emit(_mapFailureToState(f));
      }, (trendingData) {
        emit(TrendingSuccess(trending: trendingData));
      });
    });
  }

  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return TrendingError(message: 'No internet');

      case NetworkErrorFailure:
        return TrendingError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return TrendingError(
          message: 'Error',
        );
    }
  }
}
