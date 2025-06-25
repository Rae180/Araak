import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:start/core/api_service/base_Api_service.dart';
import 'package:start/core/api_service/base_repo.dart';
import 'package:start/core/constants/api_constants.dart';
import 'package:start/core/errors/failures.dart';
import 'package:start/features/Settings/Models/user_data.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final BaseApiService client;
  SettingsBloc({required this.client}) : super(SettingsInitial()) {
    on<LoadUserData>((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        final response = await client.getRequestAuth(url: ApiConstants.showpro);
        final data = jsonDecode(response.body);
        final user = UserData.fromJson(data);
        return user;
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (resonseData) {
        emit(SettingsSuccess(user: resonseData));
      });
    });
    on<UpdateUserData>(((event, emit) async {
      final result = await BaseRepo.repoRequest(request: () async {
        return await client.multipart(
            url: ApiConstants.updateuser,
            jsonBody: {
              'name': event.name,
              'phone_number': event.phone,
              'current_password': event.password,
              'new_password': event.password
            },
            file: event.image);
      });
      result.fold((f) {
        emit(_mapFailureToState(f));
      }, (responseData) {
        emit(ModSaving());
      });
    }));
  }
  _mapFailureToState(Failure f) {
    switch (f.runtimeType) {
      case OfflineFailure:
        return SettingsError(message: 'No internet');

      case NetworkErrorFailure:
        return SettingsError(
          message: (f as NetworkErrorFailure).message,
        );

      default:
        return SettingsError(
          message: 'Error',
        );
    }
  }
}
