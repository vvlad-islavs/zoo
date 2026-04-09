import 'package:flutter/foundation.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/animals/animals.dart';

class GameViewModel extends ChangeNotifier {
  GameViewModel({
    required AnimalsRepo animalsRepo,
    required AppPrefs prefs,
    required AppLogger logger,
  })  : _animalsRepo = animalsRepo,
        _prefs = prefs,
        _logger = logger;

  final AnimalsRepo _animalsRepo;
  final AppPrefs _prefs;
  final AppLogger _logger;

  AnimalQuizQuestion? _question;
  AnimalQuizQuestion? get question => _question;

  int _score = 0;
  int get score => _score;

  int get maxScore => _prefs.getMaxScore();

  bool _locked = false;
  bool get locked => _locked;

  Future<void> next() async {
    _locked = false;
    _question = await _animalsRepo.nextQuizQuestion(
      enabledTypes: _effectiveEnabledTypes(),
    );
    notifyListeners();
  }

  Set<String>? _effectiveEnabledTypes() {
    final enabled = _prefs.getEnabledAnimalTypes();
    if (enabled.isEmpty) return null;
    return enabled;
  }

  Future<void> answer(int animalId) async {
    final q = _question;
    if (q == null || _locked) return;
    _locked = true;

    final correct = q.animal.id == animalId;
    _score += correct ? 1 : -1;

    if (_score > _prefs.getMaxScore()) {
      await _prefs.setMaxScore(_score);
      _logger.i('new maxScore=$_score', tag: 'game');
    }

    notifyListeners();
  }
}

