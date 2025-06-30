import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static late SharedPreferences _prefsInstance;

  static Future<void> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
  }

  static Future<bool> hasValue(String key) async {
    return _prefsInstance.containsKey(key);
  }

  static String? getString(
    String key,
  ) {
    return _prefsInstance.getString(key);
  }

  static int? getInt(
    String key,
  ) {
    return _prefsInstance.getInt(key);
  }

  static bool? getbool(
    String key,
  ) {
    return _prefsInstance.getBool(key);
  }

  static double? getDouble(
    String key,
  ) {
    return _prefsInstance.getDouble(key);
  }

  static Future<bool> setString(String key, String value) async {
    return _prefsInstance.setString(key, value);
  }

  static Future<bool> setInt(String key, int value) async {
    return _prefsInstance.setInt(key, value);
  }

  static Future<bool> setBool(String key, bool value) async {
    return _prefsInstance.setBool(key, value);
  }

  static Future<bool> setDouble(String key, double value) async {
    return _prefsInstance.setDouble(key, value);
  }

  static setObject(String key, value) async {
    return _prefsInstance.setString(key, json.encode(value));
  }

  static dynamic getObject(String key) {
    var string = _prefsInstance.getString(key);
    if (string == null) {
      return null;
    }

    final decodedJson = json.decode(string) as dynamic;

    return decodedJson;
  }

  static Future<bool> removeValue(
    String key,
  ) async {
    return await _prefsInstance.remove(key);
  }

  static Future<bool> clearAll() async {
    return await _prefsInstance.clear();
  }

  static Future<void> saveTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', theme);
  }

  static Future<String?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('theme');
  }
}
