import 'dart:async';
import 'dart:math';

import 'package:objectbox/objectbox.dart';

import 'package:zoo/core/core.dart';
import 'package:zoo/features/animals/animals.dart';

class ObjectBoxAnimalsRepo implements AnimalsRepo {
  ObjectBoxAnimalsRepo({
    required Store store,
    required AppLogger logger,
  })  : _logger = logger,
        _box = store.box<AnimalDto>();

  final AppLogger _logger;
  final Box<AnimalDto> _box;

  @override
  Future<void> seedIfEmpty() async {
    final count = _box.count();
    if (count > 0) {
      _logger.i('seed skipped, existing=$count', tag: 'db');
      await _fixupImageUrls();
      return;
    }

    _logger.i('seeding animals...', tag: 'db');
    final items = <AnimalDto>[
      AnimalDto(
        name: 'Лев',
        type: 'Млекопитающие',
        sex: 'Самец',
        description:
            'Лев — крупная кошка, один из самых узнаваемых хищников Африки. Живёт прайдами и охотится преимущественно на копытных.',
        habitat: 'Саванны и редколесья Африки',
        factsJson: AnimalDto.encodeFacts([
          'Львицы охотятся чаще, чем львы.',
          'Рык льва слышно на расстоянии до ~8 км.',
          'Прайд — социальная группа с общими территориями.',
        ]),
        imageUrl:
            'https://pixy.org/src/466/4664233.jpg',
      ),
      AnimalDto(
        name: 'Тигр',
        type: 'Млекопитающие',
        sex: 'Самец',
        description:
            'Тигр — самый крупный представитель кошачьих. Ведёт одиночный образ жизни, охотится из засады.',
        habitat: 'Леса Азии (от тропиков до тайги)',
        factsJson: AnimalDto.encodeFacts([
          'Полосы уникальны, как отпечатки пальцев.',
          'Отлично плавает и может пересекать реки.',
          'Охотится в сумерках и ночью.',
        ]),
        imageUrl:
            'https://pixy.org/src/12/127072.jpg',
      ),
      AnimalDto(
        name: 'Панда большая',
        type: 'Млекопитающие',
        sex: 'Самка',
        description:
            'Большая панда — медведь с характерным чёрно-белым окрасом. Основу рациона составляет бамбук.',
        habitat: 'Горные бамбуковые леса Китая',
        factsJson: AnimalDto.encodeFacts([
          'Панда ест бамбук до 12–14 часов в сутки.',
          'Имеет «ложный большой палец» для удержания стеблей.',
          'Активна преимущественно днём.',
        ]),
        imageUrl:
            'https://pixy.org/src/470/4704151.jpg',
      ),
      AnimalDto(
        name: 'Жираф',
        type: 'Млекопитающие',
        sex: 'Самец',
        description:
            'Жираф — самое высокое наземное животное. Питается листьями деревьев, особенно акации.',
        habitat: 'Саванны Африки',
        factsJson: AnimalDto.encodeFacts([
          'Язык жирафа может достигать ~45 см.',
          'Сердце весит до ~11 кг.',
          'Рисунок пятен уникален у каждого жирафа.',
        ]),
        imageUrl:
            'https://pixy.org/src2/604/6041007.jpg',
      ),
      AnimalDto(
        name: 'Пингвин императорский',
        type: 'Птицы',
        sex: 'Самец',
        description:
            'Императорский пингвин — крупнейший из пингвинов. Прекрасно адаптирован к холоду и ныряет за рыбой и крилем.',
        habitat: 'Антарктика',
        factsJson: AnimalDto.encodeFacts([
          'Самцы высиживают яйцо на лапах под складкой кожи.',
          'Ныряет на глубину более 500 м.',
          'Образует плотные «кучки» для сохранения тепла.',
        ]),
        imageUrl:
            'https://pixy.org/src/468/4680975.jpg',
      ),
      AnimalDto(
        name: 'Орёл беркут',
        type: 'Птицы',
        sex: 'Самка',
        description:
            'Беркут — крупный хищный орёл. Обладает острым зрением и охотится на мелких и средних животных.',
        habitat: 'Горы и открытые пространства Евразии и Сев. Америки',
        factsJson: AnimalDto.encodeFacts([
          'Зрение значительно острее человеческого.',
          'Строит крупные гнёзда, используемые много лет.',
          'Скорость в пикировании может быть очень высокой.',
        ]),
        imageUrl:
            'https://pixy.org/src2/656/6565906.jpg',
      ),
      AnimalDto(
        name: 'Крокодил нильский',
        type: 'Рептилии',
        sex: 'Самец',
        description:
            'Нильский крокодил — один из крупнейших современных крокодилов. Засадный хищник, часто охотится у воды.',
        habitat: 'Реки и озёра Африки',
        factsJson: AnimalDto.encodeFacts([
          'Может долго оставаться под водой, задерживая дыхание.',
          'Температура тела зависит от среды.',
          'Имеет мощнейшие челюсти.',
        ]),
        imageUrl:
            'https://pixy.org/src2/613/6131068.jpg',
      ),
      AnimalDto(
        name: 'Черепаха зелёная',
        type: 'Рептилии',
        sex: 'Самка',
        description:
            'Зелёная морская черепаха — крупная морская черепаха, в зрелом возрасте питается в основном растительностью.',
        habitat: 'Тропические и субтропические моря',
        factsJson: AnimalDto.encodeFacts([
          'Может мигрировать на большие расстояния.',
          'Ориентируется по магнитному полю Земли.',
          'Выходит на берег для откладывания яиц.',
        ]),
        imageUrl:
            'https://pixy.org/src2/602/6025487.jpg',
      ),
    ];

    _box.putMany(items);
    _logger.i('seed done, inserted=${items.length}', tag: 'db');
  }

  Future<void> _fixupImageUrls() async {
    final byName = <String, String>{
      'Лев': 'https://pixy.org/src/466/4664233.jpg',
      'Тигр': 'https://pixy.org/src/12/127072.jpg',
      'Панда большая': 'https://pixy.org/src/470/4704151.jpg',
      'Жираф': 'https://pixy.org/src2/604/6041007.jpg',
      'Пингвин императорский': 'https://pixy.org/src/468/4680975.jpg',
      'Орёл беркут': 'https://pixy.org/src2/656/6565906.jpg',
      'Крокодил нильский': 'https://pixy.org/src2/613/6131068.jpg',
      'Черепаха зелёная': 'https://pixy.org/src2/602/6025487.jpg',
    };

    final all = _box.getAll();
    var changed = 0;
    for (final dto in all) {
      final expected = byName[dto.name];
      if (expected == null) continue;
      if (dto.imageUrl == expected) continue;
      dto.imageUrl = expected;
      _box.put(dto);
      changed++;
    }
    if (changed > 0) {
      _logger.i('imageUrl fixup: $changed', tag: 'db');
    }
  }

  @override
  Stream<List<Animal>> watchAnimals({Set<String>? enabledTypes}) {
    final enabled = enabledTypes ?? const <String>{};
    return _box.query().watch(triggerImmediately: true).map((q) {
      try {
        final dtos = q.find();
        final filtered = enabled.isEmpty
            ? dtos
            : dtos.where((e) => enabled.contains(e.type)).toList();
        return filtered.map(_map).toList(growable: false);
      } finally {
        q.close();
      }
    });
  }

  @override
  Future<Animal?> getById(int id) async {
    final dto = _box.get(id);
    return dto == null ? null : _map(dto);
  }

  @override
  Future<List<String>> getAllTypes() async {
    final types = _box.getAll().map((e) => e.type).toSet().toList()..sort();
    return types;
  }

  @override
  Future<AnimalQuizQuestion?> nextQuizQuestion({Set<String>? enabledTypes}) async {
    final enabled = enabledTypes ?? const <String>{};
    final allRaw = _box.getAll();
    final all = enabled.isEmpty
        ? allRaw
        : allRaw.where((e) => enabled.contains(e.type)).toList();

    if (all.length < 2) return null;

    final rnd = Random();
    final correctDto = all[rnd.nextInt(all.length)];

    final optionsCount = min(4, all.length);
    final pool = List<AnimalDto>.from(all)..remove(correctDto);
    pool.shuffle(rnd);

    final options = <AnimalDto>[
      correctDto,
      ...pool.take(optionsCount - 1),
    ]..shuffle(rnd);

    return AnimalQuizQuestion(
      animal: _map(correctDto),
      options: options.map(_map).toList(growable: false),
    );
  }

  Animal _map(AnimalDto dto) {
    return Animal(
      id: dto.id,
      name: dto.name,
      type: dto.type,
      sex: dto.sex,
      description: dto.description,
      habitat: dto.habitat,
      facts: AnimalDto.decodeFacts(dto.factsJson),
      imageUrl: dto.imageUrl,
    );
  }
}
