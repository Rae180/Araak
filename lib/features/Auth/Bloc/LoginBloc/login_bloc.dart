// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BaseApiService client;
  LoginBloc({
    required this.client,
  }) : super(LoginInitial()) {
    on<LoginUserEvent>((event, emit) async {
      emit(LoginingLoading());
      final data = await BaseRepo.repoRequest(request: () async {
        return await client.postRequest(url: ApiConstants.login, jsonBody: {
          'email': event.email,
          'password': event.password,
        });
      });
      await data.fold((f) async => emit(_mapFailureToState(f)),
          (responseData) async {
        final token = responseData['token'] as String;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        print("token saved here : $token");
        emit(LoginSuccess());
      });
    });
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return LoginError(message: 'No internet');
      case NetworkErrorFailure:
        return LoginError(message: (f as NetworkErrorFailure).message);
      default:
        return LoginError(message: 'Error');
    }
  }
}
