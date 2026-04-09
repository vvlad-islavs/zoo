import 'package:flutter/material.dart';

import 'package:zoo/core/core.dart';

class SettingsViewModel extends ChangeNotifier {
  SettingsViewModel({
    required AppPrefs prefs,
    required ValueNotifier<ThemeMode> themeMode,
    required AppLogger logger,
  })  : _prefs = prefs,
        _themeMode = themeMode,
        _logger = logger;

  final AppPrefs _prefs;
  final ValueNotifier<ThemeMode> _themeMode;
  final AppLogger _logger;

  ThemeMode get themeMode => _themeMode.value;

  Future<void> setThemeMode(ThemeMode v) async {
    await _prefs.setThemeMode(v);
    _themeMode.value = v;
    _logger.i('themeMode=$v', tag: 'settings');
    notifyListeners();
  }
}

