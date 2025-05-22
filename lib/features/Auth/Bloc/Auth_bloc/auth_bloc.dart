import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuth>((event, emit) async {
      emit(AuthLoading());
      await Future.delayed(
        Duration(seconds: 2),
      );
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token != null && token.isNotEmpty) {
        emit(AuthSuccess());
      } else {
        emit(UnAuth());
      }
    });
  }
}
