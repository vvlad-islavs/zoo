import 'dart:convert';

import 'package:objectbox/objectbox.dart';

@Entity()
class AnimalDto {
  AnimalDto({
    this.id = 0,
    required this.name,
    required this.type,
    required this.sex,
    required this.description,
    required this.habitat,
    required this.factsJson,
    required this.imageUrl,
  });

  @Id()
  int id;

  @Index()
  String name;

  @Index()
  String type;

  String sex;
  String description;
  String habitat;
  String factsJson;
  String imageUrl;

  static String encodeFacts(List<String> facts) => jsonEncode(facts);

  static List<String> decodeFacts(String factsJson) {
    final v = jsonDecode(factsJson);
    if (v is List) {
      return v.whereType<String>().toList(growable: false);
    }
    return const <String>[];
  }
}

