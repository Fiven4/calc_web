import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Настройки, которые переживают перезагрузку страницы
/// (в браузере shared_preferences хранит их в localStorage).
class AppStorage {
  AppStorage._();

  static const _themeKey = 'theme_mode';
  static const _fromKey = 'converter_from';
  static const _toKey = 'converter_to';

  static late SharedPreferences _prefs;

  /// Текущая тема; MaterialApp перестраивается при её изменении.
  static final ValueNotifier<ThemeMode> themeMode = ValueNotifier(
    ThemeMode.light,
  );

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    themeMode.value = _prefs.getString(_themeKey) == 'dark'
        ? ThemeMode.dark
        : ThemeMode.light;
  }

  static Future<void> setDarkTheme(bool dark) {
    themeMode.value = dark ? ThemeMode.dark : ThemeMode.light;
    return _prefs.setString(_themeKey, dark ? 'dark' : 'light');
  }

  /// Последняя выбранная пара валют или null, если её ещё не сохраняли.
  static (String, String)? get lastPair {
    final from = _prefs.getString(_fromKey);
    final to = _prefs.getString(_toKey);
    if (from == null || to == null) return null;
    return (from, to);
  }

  static Future<void> saveLastPair(String from, String to) async {
    await _prefs.setString(_fromKey, from);
    await _prefs.setString(_toKey, to);
  }
}
