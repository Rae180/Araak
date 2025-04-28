import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:start/core/managers/languages_manager.dart';

import '../localize_app.dart';

part 'lacalization_state.dart';

class LacalizationCubit extends Cubit<LacalizationState> {
  final LocalizeApp localizeApp;
  LacalizationCubit(
    this.localizeApp,
  ) : super(
          const LacalizationState(
            locale: Locale(LanguagesManager.English),
          ),
        );

  Future<void> getSavedLanguage() async {
    String cachedLang = await localizeApp.getCachedLanguageCode();

    emit(
      LacalizationState(
        locale: Locale(
          cachedLang,
        ),
      ),
    );
  }

  Future<void> changeLanguage(String languageCode) async {
    await localizeApp.cacheLanguageCode(languageCode);
    emit(
      LacalizationState(
        locale: Locale(
          languageCode,
        ),
      ),
    );
  }
}
