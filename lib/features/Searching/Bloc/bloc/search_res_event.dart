part of 'search_res_bloc.dart';

class SearchResEvent {}

final class GetSearchResultsEvent extends SearchResEvent {
  final String query;

  GetSearchResultsEvent({required this.query});
}
