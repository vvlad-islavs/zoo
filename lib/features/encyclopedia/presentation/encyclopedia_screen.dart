import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/animals/animals.dart';
import 'package:zoo/features/encyclopedia/encyclopedia.dart';

@RoutePage()
class EncyclopediaScreen extends StatefulWidget {
  const EncyclopediaScreen({super.key});

  @override
  State<EncyclopediaScreen> createState() => _EncyclopediaScreenState();
}

class _EncyclopediaScreenState extends State<EncyclopediaScreen> {
  late final EncyclopediaViewModel _vm = EncyclopediaViewModel(
    repo: getIt<AnimalsRepo>(),
    prefs: getIt<AppPrefs>(),
    logger: getIt<AppLogger>(),
  )..init();

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Энциклопедия'),
        actions: [
          IconButton(
            tooltip: 'Фильтр',
            onPressed: () => _openFilter(context),
            icon: const Icon(Icons.tune),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _vm,
        builder: (context, _) {
          final items = _vm.animals;
          if (items.isEmpty) {
            return const Center(child: Text('Пока нет животных'));
          }

          final w = MediaQuery.sizeOf(context).width;
          final crossAxisCount = w >= 900 ? 4 : (w >= 600 ? 3 : 2);

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.78,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) {
              final a = items[i];
              return _AnimalCard(
                animal: a,
                onTap: () => context.router.push(
                  AnimalDetailsRoute(animalId: a.id),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _openFilter(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return AnimatedBuilder(
          animation: _vm,
          builder: (context, _) {
            final types = _vm.types;
            final enabled = _vm.enabledTypes;

            return SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: [
                  Row(
                    children: [
                      Text(
                        'Типы животных',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _vm.setAllTypesEnabled(true),
                        child: const Text('Все'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (types.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    ...types.map((t) {
                      final selected = enabled.isEmpty ? true : enabled.contains(t);
                      return SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t),
                        value: selected,
                        onChanged: (v) => _vm.setTypeEnabled(t, v),
                      );
                    }),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _AnimalCard extends StatelessWidget {
  const _AnimalCard({
    required this.animal,
    required this.onTap,
  });

  final Animal animal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: AppNetworkImage(url: animal.imageUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    animal.name,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    animal.type,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

