part of 'theme_bloc.dart';

abstract class ThemeState {}

class ThemeInitial extends ThemeState {}

class ThemeLoaded extends ThemeState {
  final bool isDarkMode;
  
  ThemeLoaded({required this.isDarkMode});
}

class ThemeError extends ThemeState {
  final String message;
  
  ThemeError({required this.message});
}