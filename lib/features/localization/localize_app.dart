abstract class LocalizeApp {
  Future<void> cacheLanguageCode(String language);
  Future<String> getCachedLanguageCode();
}
