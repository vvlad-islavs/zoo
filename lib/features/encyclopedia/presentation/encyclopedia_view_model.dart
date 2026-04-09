import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/animals/animals.dart';

class EncyclopediaViewModel extends ChangeNotifier {
  EncyclopediaViewModel({
    required AnimalsRepo repo,
    required AppPrefs prefs,
    required AppLogger logger,
  })  : _repo = repo,
        _prefs = prefs,
        _logger = logger;

  final AnimalsRepo _repo;
  final AppPrefs _prefs;
  final AppLogger _logger;

  StreamSubscription<List<Animal>>? _sub;

  List<Animal> _animals = const [];
  List<Animal> get animals => _animals;

  List<String> _types = const [];
  List<String> get types => _types;

  Set<String> get enabledTypes => _prefs.getEnabledAnimalTypes();

  void init() {
    _loadTypes();
    _sub ??= _repo
        .watchAnimals(enabledTypes: _effectiveEnabledTypes())
        .listen((items) {
      _animals = items;
      notifyListeners();
    }, onError: (e, st) {
      _logger.e('watchAnimals error', tag: 'encyclopedia', error: e, st: st);
    });
  }

  Future<void> _loadTypes() async {
    try {
      _types = await _repo.getAllTypes();
      notifyListeners();
    } catch (e, st) {
      _logger.e('getAllTypes error', tag: 'encyclopedia', error: e, st: st);
    }
  }

  Set<String>? _effectiveEnabledTypes() {
    final enabled = _prefs.getEnabledAnimalTypes();
    if (enabled.isEmpty) return null;
    return enabled;
  }

  Future<void> setTypeEnabled(String type, bool enabled) async {
    final current = _prefs.getEnabledAnimalTypes();
    final Set<String> next;

    // Semantics:
    // - empty set in prefs => "all types enabled"
    // - non-empty set => only those types are enabled
    if (current.isEmpty) {
      if (enabled) {
        // Already enabled (all enabled).
        return;
      }
      // First "disable" from the "all enabled" state:
      // turn into explicit allow-list = all types minus disabled one.
      next = _types.toSet()..remove(type);
    } else {
      next = current;
      if (enabled) {
        next.add(type);
      } else {
        next.remove(type);
      }
    }

    // If user ended up enabling everything explicitly - collapse to "all".
    if (next.length == _types.length) {
      next.clear();
    }

    await _prefs.setEnabledAnimalTypes(next);
    _logger.i('enabledTypes=${next.length}', tag: 'encyclopedia');

    await _sub?.cancel();
    _sub = null;
    init();
  }

  Future<void> setAllTypesEnabled(bool enabled) async {
    if (enabled) {
      await _prefs.setEnabledAnimalTypes(<String>{});
    } else {
      final all = await _repo.getAllTypes();
      await _prefs.setEnabledAnimalTypes(all.toSet());
    }
    await _sub?.cancel();
    _sub = null;
    init();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}

