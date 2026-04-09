import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/animals/animals.dart';

@RoutePage()
class AnimalDetailsScreen extends StatefulWidget {
  const AnimalDetailsScreen({
    required this.animalId,
    super.key,
  });

  final int animalId;

  @override
  State<AnimalDetailsScreen> createState() => _AnimalDetailsScreenState();
}

class _AnimalDetailsScreenState extends State<AnimalDetailsScreen> {
  late final ValueNotifier<Animal?> _animal = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = getIt<AnimalsRepo>();
    final a = await repo.getById(widget.animalId);
    _animal.value = a;
  }

  @override
  void dispose() {
    _animal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _animal,
      builder: (context, a, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(a?.name ?? 'Животное'),
          ),
          body: a == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    AppNetworkImage(
                      url: a.imageUrl,
                      borderRadius: BorderRadius.circular(16),
                      aspectRatio: 16 / 9,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text(a.type)),
                        Chip(label: Text(a.sex)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      a.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Место обитания',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    Text(a.habitat),
                    const SizedBox(height: 16),
                    Text(
                      'Интересные факты',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 6),
                    ...a.facts.map(
                      (f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• '),
                            Expanded(child: Text(f)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

