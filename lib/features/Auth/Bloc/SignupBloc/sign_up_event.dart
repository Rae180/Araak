part of 'sign_up_bloc.dart';

class SignUpEvent {}

final class SignupUserEvent extends SignUpEvent {
  final User user;
  final String fcm;

  SignupUserEvent({required this.user,required this.fcm});
}
