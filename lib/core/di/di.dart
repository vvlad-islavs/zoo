import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/features.dart';
import 'package:zoo/objectbox.g.dart';

final getIt = GetIt.instance;

Future<void> initDi() async {
  if (getIt.isRegistered<AppLogger>()) return;

  final logger = AppLogger();
  getIt.registerSingleton<AppLogger>(logger);

  final sp = await SharedPreferences.getInstance();
  final prefs = AppPrefs(sp);
  getIt.registerSingleton<AppPrefs>(prefs);

  final themeModeNotifier = ValueNotifier<ThemeMode>(prefs.getThemeMode());
  getIt.registerSingleton<ValueNotifier<ThemeMode>>(themeModeNotifier);

  logger.i('opening objectbox store', tag: 'db');
  final store = await openStore();
  getIt.registerSingleton<Store>(store);

  final animalsRepo = ObjectBoxAnimalsRepo(
    store: store,
    logger: logger,
  );
  getIt.registerSingleton<AnimalsRepo>(animalsRepo);

  await animalsRepo.seedIfEmpty();

  final router = AppRouter();
  getIt.registerSingleton<AppRouter>(router);

  final navObserver = AppRouteObserver(logger);
  getIt.registerSingleton<AutoRouterObserver>(navObserver);
}

