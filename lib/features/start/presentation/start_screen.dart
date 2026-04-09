import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/start/start.dart';

@RoutePage()
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late final StartViewModel _vm = StartViewModel(prefs: getIt<AppPrefs>());

  @override
  Widget build(BuildContext context) {
    final max = _vm.maxScore;
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cs.primaryContainer.withValues(alpha: 0.85),
              cs.secondaryContainer.withValues(alpha: 0.75),
              cs.tertiaryContainer.withValues(alpha: 0.65),
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: c.maxHeight),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Зоопарк',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Энциклопедия животных и мини‑игра\n«угадай по фото».',
                            style: Theme.of(context).textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          _MenuCard(
                            title: 'Играть',
                            subtitle: 'Рекорд: $max',
                            icon: Icons.sports_esports_outlined,
                            onTap: () => context.router.push(const GameRoute()),
                          ),
                          const SizedBox(height: 12),
                          _MenuCard(
                            title: 'Энциклопедия',
                            subtitle: 'Все животные и факты',
                            icon: Icons.grid_view_rounded,
                            onTap: () =>
                                context.router.push(const EncyclopediaRoute()),
                          ),
                          const SizedBox(height: 12),
                          _MenuCard(
                            title: 'Настройки',
                            subtitle: 'Тема приложения',
                            icon: Icons.settings_outlined,
                            onTap: () =>
                                context.router.push(const SettingsRoute()),
                          ),
                          const SizedBox(height: 18),
                          TextButton.icon(
                            onPressed: () => _exitApp(context),
                            icon: const Icon(Icons.exit_to_app_outlined),
                            label: const Text('Выйти'),
                            style: TextButton.styleFrom(
                              foregroundColor: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _exitApp(BuildContext context) {
    SystemNavigator.pop();
  }
}

class _MenuCard extends StatelessWidget {
  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surface.withValues(alpha: 0.75),
      elevation: 0,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: cs.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

