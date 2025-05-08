import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/home/Models/Category.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final BaseApiService client;
  CategoryBloc({
    required this.client,
  }) : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      final data = await BaseRepo.repoRequest(request: () async {
        var data = await client.getRequest(url: ApiConstants.getcat);
        List<Category> categories = [];
        data['categories']
            .forEach((element) => categories.add(Category.fromJson(element)));
        return categories;
      });
      data.fold((f) {
        emit(_mapFailureToState(f));
      }, (data) {
        print('hello is that me are u looking for ??');
        emit(CategorySuccess(category: data));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return CategoryError(message: 'No internet');

      case NetworkErrorFailure:
        return CategoryError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return CategoryError(
          message: 'Error',
        );
    }
  }
}
