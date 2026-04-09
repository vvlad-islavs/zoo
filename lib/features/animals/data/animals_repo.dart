import 'package:zoo/features/animals/domain/animal.dart';

abstract interface class AnimalsRepo {
  Future<void> seedIfEmpty();

  Stream<List<Animal>> watchAnimals({Set<String>? enabledTypes});

  Future<Animal?> getById(int id);

  Future<List<String>> getAllTypes();

  Future<AnimalQuizQuestion?> nextQuizQuestion({Set<String>? enabledTypes});
}

class AnimalQuizQuestion {
  const AnimalQuizQuestion({
    required this.animal,
    required this.options,
  });

  final Animal animal;
  final List<Animal> options;
}

