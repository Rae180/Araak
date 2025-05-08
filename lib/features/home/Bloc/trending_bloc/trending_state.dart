part of 'trending_bloc.dart';

class TrendingState {}

final class TrendingInitial extends TrendingState {}

final class TrendingLoading extends TrendingState {}

final class TrendingSuccess extends TrendingState {
  final Trending trending;

  TrendingSuccess({required this.trending});
}

final class TrendingError extends TrendingState {
  final String message;

  TrendingError({required this.message});
}
