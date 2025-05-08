part of 'recommend_bloc.dart';

class RecommendState {}

final class RecommendInitial extends RecommendState {}

final class RecomendLoading extends RecommendState {}

final class RecomendSuccess extends RecommendState {
  final RecommendModel recommend;

  RecomendSuccess({required this.recommend});
}

final class RecommendError extends RecommendState {
  final String message;

  RecommendError({required this.message});
}
