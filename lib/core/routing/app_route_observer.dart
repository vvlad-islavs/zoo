import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';

import '../logging/app_logger.dart';

class AppRouteObserver extends AutoRouterObserver {
  AppRouteObserver(this._logger);

  final AppLogger _logger;

  @override
  void didPush(Route route, Route? previousRoute) {
    _logger.i(
      'push: ${route.settings.name} from ${previousRoute?.settings.name}',
      tag: 'nav',
    );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _logger.i(
      'pop: ${route.settings.name} to ${previousRoute?.settings.name}',
      tag: 'nav',
    );
    super.didPop(route, previousRoute);
  }
}

