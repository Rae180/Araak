part of 'search_res_bloc.dart';

class SearchResState {}

final class SearchResInitial extends SearchResState {}

final class SearchLoading extends SearchResState{}

final class SearchSuccess extends SearchResState {
  final SearchResult results;

  SearchSuccess({required this.results});
}

final class SearchError extends SearchResState {
  final String message;

  SearchError({required this.message});
}
