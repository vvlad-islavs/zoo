import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/game/game.dart';

@RoutePage()
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final GameViewModel _vm = GameViewModel(
    animalsRepo: getIt(),
    prefs: getIt(),
    logger: getIt(),
  );

  @override
  void initState() {
    super.initState();
    _vm.next();
  }

  @override
  void dispose() {
    _vm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _vm,
          builder: (context, _) => Text(
            'Игра • ${_vm.score} (рекорд: ${_vm.maxScore})',
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _vm,
        builder: (context, _) {
          final q = _vm.question;
          if (q == null) {
            return const Center(child: Text('Недостаточно данных'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AppNetworkImage(
                url: q.animal.imageUrl,
                borderRadius: BorderRadius.circular(16),
                aspectRatio: 16 / 9,
              ),
              const SizedBox(height: 16),
              Text(
                'Кто это?',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              for (final opt in q.options)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: FilledButton.tonal(
                    onPressed: _vm.locked
                        ? null
                        : () async {
                            await _vm.answer(opt.id);
                            await Future<void>.delayed(
                              const Duration(milliseconds: 350),
                            );
                            await _vm.next();
                          },
                    child: Text(opt.name),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

