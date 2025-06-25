part of 'settings_bloc.dart';

class SettingsEvent {}

final class LoadUserData extends SettingsEvent {}

final class UpdateUserData extends SettingsEvent {
  final String? name;
  final String password;
  final String phone;
  final File? image;

  UpdateUserData(
      {required this.name,
      required this.password,
      required this.phone,
      required this.image});
}
