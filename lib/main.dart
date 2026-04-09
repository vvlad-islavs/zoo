import 'dart:async';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:zoo/core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();

  final logger = getIt<AppLogger>();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    logger.e(
      details.exceptionAsString(),
      tag: 'flutter_error',
      error: details.exception,
      st: details.stack,
    );
  };

  PlatformDispatcher.instance.onError = (error, st) {
    logger.e('uncaught platform error', tag: 'zone', error: error, st: st);
    return true;
  };

  // Log first frame time (helpful for startup issues)
  SchedulerBinding.instance.addPostFrameCallback((_) {
    logger.i('first frame rendered', tag: 'app');
  });

  runZonedGuarded(
    () => runApp(const _App()),
    (error, st) => logger.e('uncaught zone error', tag: 'zone', error: error, st: st),
  );
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    final themeModeNotifier = getIt<ValueNotifier<ThemeMode>>();
    final router = getIt<AppRouter>();
    final navObserver = getIt<AutoRouterObserver>();

    return ValueListenableBuilder(
      valueListenable: themeModeNotifier,
      builder: (context, themeMode, _) {
        return MaterialApp.router(
          title: 'Zoo',
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: themeMode,
          debugShowCheckedModeBanner: false,
          routerConfig: router.config(
            navigatorObservers: () => [navObserver],
          ),
        );
      },
    );
  }
}

