import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  AppPrefs(this._sp);

  final SharedPreferences _sp;

  static const _kThemeMode = 'theme_mode';
  static const _kMaxScore = 'max_score';
  static const _kEnabledTypes = 'enabled_animal_types';

  ThemeMode getThemeMode() {
    final v = _sp.getString(_kThemeMode);
    return switch (v) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final v = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await _sp.setString(_kThemeMode, v);
  }

  int getMaxScore() => _sp.getInt(_kMaxScore) ?? 0;

  Future<void> setMaxScore(int score) => _sp.setInt(_kMaxScore, score);

  Set<String> getEnabledAnimalTypes() =>
      (_sp.getStringList(_kEnabledTypes) ?? const <String>[]).toSet();

  Future<void> setEnabledAnimalTypes(Set<String> types) =>
      _sp.setStringList(_kEnabledTypes, types.toList()..sort());
}

