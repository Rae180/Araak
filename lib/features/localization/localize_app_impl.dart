import 'package:start/core/managers/languages_manager.dart';

import '../../core/utils/services/shared_preferences.dart';
import 'localize_app.dart';

class LocalizeAppImpl implements LocalizeApp {
  final kLanguage = 'LANGUAGE';

  @override
  Future<void> cacheLanguageCode(String language) async {
    await PreferenceUtils.setString(kLanguage, language);
  }

  @override
  Future<String> getCachedLanguageCode() async {
    String? lang =  PreferenceUtils.getString(
      kLanguage,
    );
    print(lang);
    if (lang != null) {
      return lang;
    } else {
      return LanguagesManager.English;
    }
  }
}
