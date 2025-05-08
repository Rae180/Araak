part of 'sign_up_bloc.dart';

class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SigningUpLoading extends SignUpState {}

final class SignupSuccess extends SignUpState {}

final class SignupError extends SignUpState {
  final String message;

  SignupError({required this.message});
}
