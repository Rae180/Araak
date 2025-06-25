part of 'settings_bloc.dart';

class SettingsState {}

final class SettingsInitial extends SettingsState {}

final class SettingsLoading extends SettingsState {}

final class SettingsSuccess extends SettingsState {
  final UserData user;

  SettingsSuccess({required this.user});
}
final class ModSaving extends SettingsState{}

final class SettingsError extends SettingsState {
  final String message;

  SettingsError({required this.message});
}
