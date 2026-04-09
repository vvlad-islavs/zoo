import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zoo/core/core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDi();
  runApp(const _App());
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

