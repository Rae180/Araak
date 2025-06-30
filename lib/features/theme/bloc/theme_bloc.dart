// features/theme/bloc/theme_bloc.dart
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(ThemeInitial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ToggleTheme>(_onToggleTheme);
  }

  static const String themeKey = 'theme';

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(themeKey);
      emit(ThemeLoaded(isDarkMode: savedTheme == 'dark'));
    } catch (e) {
      emit(ThemeError(message: 'Failed to load theme preference'));
    }
  }

  Future<void> _onToggleTheme(ToggleTheme event, Emitter<ThemeState> emit) async {
    if (state is ThemeLoaded) {
      final currentState = state as ThemeLoaded;
      final newMode = !currentState.isDarkMode;
      
      // Emit the new state immediately for UI update
      emit(ThemeLoaded(isDarkMode: newMode));
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(themeKey, newMode ? 'dark' : 'light');
      } catch (e) {
        // If save fails, revert to previous state
        emit(ThemeLoaded(isDarkMode: currentState.isDarkMode));
        emit(ThemeError(message: 'Failed to save theme preference'));
      }
    }
    // If state is not loaded yet, load it first
    else {
      add(LoadTheme());
    }
  }
}