part of 'login_bloc.dart';

class LoginEvent {}

class LoginUserEvent extends LoginEvent {
  final String email;
  final String password;

  LoginUserEvent({required this.email, required this.password});
}
