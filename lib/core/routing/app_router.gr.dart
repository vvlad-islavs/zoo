// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AnimalDetailsScreen]
class AnimalDetailsRoute extends PageRouteInfo<AnimalDetailsRouteArgs> {
  AnimalDetailsRoute({
    required int animalId,
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
         AnimalDetailsRoute.name,
         args: AnimalDetailsRouteArgs(animalId: animalId, key: key),
         initialChildren: children,
       );

  static const String name = 'AnimalDetailsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AnimalDetailsRouteArgs>();
      return AnimalDetailsScreen(animalId: args.animalId, key: args.key);
    },
  );
}

class AnimalDetailsRouteArgs {
  const AnimalDetailsRouteArgs({required this.animalId, this.key});

  final int animalId;

  final Key? key;

  @override
  String toString() {
    return 'AnimalDetailsRouteArgs{animalId: $animalId, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AnimalDetailsRouteArgs) return false;
    return animalId == other.animalId && key == other.key;
  }

  @override
  int get hashCode => animalId.hashCode ^ key.hashCode;
}

/// generated route for
/// [EncyclopediaScreen]
class EncyclopediaRoute extends PageRouteInfo<void> {
  const EncyclopediaRoute({List<PageRouteInfo>? children})
    : super(EncyclopediaRoute.name, initialChildren: children);

  static const String name = 'EncyclopediaRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const EncyclopediaScreen();
    },
  );
}

/// generated route for
/// [GameScreen]
class GameRoute extends PageRouteInfo<void> {
  const GameRoute({List<PageRouteInfo>? children})
    : super(GameRoute.name, initialChildren: children);

  static const String name = 'GameRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const GameScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [StartScreen]
class StartRoute extends PageRouteInfo<void> {
  const StartRoute({List<PageRouteInfo>? children})
    : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StartScreen();
    },
  );
}
