import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/ProductsFolder/Models/DiscountedRoom.dart';

part 'discounts_event.dart';
part 'discounts_state.dart';

class DiscountsBloc extends Bloc<DiscountsEvent, DiscountsState> {
  final BaseApiService client;
  DiscountsBloc({required this.client}) : super(DiscountsInitial()) {
    on<GetDiscountsDeailesEvent>((event, emit) async {
      emit(DiscountsLoading());
      final resulte = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequest(
            url: ApiConstants.getdis + event.discountId.toString());
        final data = DiscountModel.fromJson(response);
        return data;
      });
      resulte.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(DiscountsDetailesSuccess(discount: responseData));
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return DiscountsError(message: 'No internet');

      case NetworkErrorFailure:
        return DiscountsError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return DiscountsError(
          message: 'Error',
        );
    }
  }
}
