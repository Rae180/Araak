// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Auth/Models/User.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final BaseApiService client;

  SignUpBloc({
    required this.client,
  }) : super(SignUpInitial()) {
    on<SignupUserEvent>((event, emit) async {
      print('hi 1 1');
      emit(SigningUpLoading());

      final data = await BaseRepo.repoRequest(request: () async {
        print('hi');
        // Return the result from the multipart request
        return await client.multipart(
          url: ApiConstants.register,
          jsonBody: {
            "name": event.user.name,
            "email": event.user.email,
            "password": event.user.password,
            "C_password": event.user.C_password,
            "phone_number": event.user.phoneNumber,
          },
          file: event.user.profileImage,
        );
      });

      // Emit the states based on whether the call was successful or not
     await data.fold(
        (f) async => emit(_mapFailureToState(f)),
        (responseData) async {
          final token = responseData['token'] as String;
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          print("token saved here : $token");
          emit(SignupSuccess());
        },
      );
    });
  }

  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return SignupError(message: 'No internet');
      case NetworkErrorFailure:
        return SignupError(message: (f as NetworkErrorFailure).message);
      default:
        return SignupError(message: 'Error');
    }
  }
}
