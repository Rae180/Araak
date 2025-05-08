part of 'category_bloc.dart';

class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final List<Category> category;

  CategorySuccess({required this.category});
}

final class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});
}
