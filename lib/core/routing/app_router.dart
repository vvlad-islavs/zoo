import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import 'package:zoo/features/features.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: StartRoute.page, initial: true),
        AutoRoute(page: EncyclopediaRoute.page),
        AutoRoute(page: AnimalDetailsRoute.page),
        AutoRoute(page: SettingsRoute.page),
        AutoRoute(page: GameRoute.page),
      ];
}

