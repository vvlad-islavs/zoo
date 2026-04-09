import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/settings/settings.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsViewModel _vm = SettingsViewModel(
    prefs: getIt<AppPrefs>(),
    themeMode: getIt(),
    logger: getIt(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: AnimatedBuilder(
        animation: _vm,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('Тема', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, c) {
                  if (c.maxWidth < 420) {
                    return DropdownButtonFormField<ThemeMode>(
                      initialValue: _vm.themeMode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('Системная'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Светлая'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Тёмная'),
                        ),
                      ],
                      onChanged: (v) => v == null ? null : _vm.setThemeMode(v),
                    );
                  }
                  return SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('Системная'),
                      ),
                      ButtonSegment(value: ThemeMode.light, label: Text('Светлая')),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Тёмная')),
                    ],
                    selected: {_vm.themeMode},
                    onSelectionChanged: (s) => _vm.setThemeMode(s.first),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

