import 'package:flutter/foundation.dart';

import 'package:zoo/core/core.dart';

class StartViewModel extends ChangeNotifier {
  StartViewModel({
    required AppPrefs prefs,
  }) : _prefs = prefs;

  final AppPrefs _prefs;

  int get maxScore => _prefs.getMaxScore();
}

