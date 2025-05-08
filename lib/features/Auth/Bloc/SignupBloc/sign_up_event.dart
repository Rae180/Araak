part of 'sign_up_bloc.dart';

class SignUpEvent {}

final class SignupUserEvent extends SignUpEvent {
  final User user;

  SignupUserEvent({required this.user});

}
