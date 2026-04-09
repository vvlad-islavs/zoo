class Animal {
  const Animal({
    required this.id,
    required this.name,
    required this.type,
    required this.sex,
    required this.description,
    required this.habitat,
    required this.facts,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String type;
  final String sex;
  final String description;
  final String habitat;
  final List<String> facts;
  final String imageUrl;
}

