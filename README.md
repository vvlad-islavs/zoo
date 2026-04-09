# Zoo (Flutter)

Мини‑проект «Зоопарк»: энциклопедия животных + игра «угадай по фото».

## Функциональность

- **Стартовый экран**: играть (показывает рекорд), энциклопедия, настройки, выход.
- **Энциклопедия**: grid‑список животных (имя + фото), переход в карточку животного.
- **Карточка животного**: описание, место обитания, факты.
- **Игра**: показывается фото и варианты ответа. Верно \(+1\), неверно \(-1\).
- **Настройки**: тема (system/light/dark).
- **Рекорд**: хранится в `SharedPreferences`.
- **Животные**: хранятся локально в `ObjectBox`. При первом запуске выполняется сидинг.
- **Картинки**: грузятся по сети с кэшированием (через `cached_network_image`).

## Архитектура (упрощённый Clean)

- **`core/`**: общие сервисы и инфраструктура
  - DI: `GetIt` (`core/di/di.dart`)
  - логирование: `AppLogger`
  - prefs: `AppPrefs` (тема/рекорд/фильтр типов)
  - навигация: `AutoRoute` + observer (логирует push/pop)
  - UI: `AppNetworkImage`
- **`features/`**: фичи (data/domain/presentation)
  - `animals`: DTO (ObjectBox) + entity (UI) + repo
  - `start`, `encyclopedia`, `game`, `settings`: экраны + view model (ChangeNotifier)

Импорты — через barrel‑файлы (`core/core.dart`, `features/features.dart`).

## Как это работает (кратко)

- При старте `main.dart` вызывает `initDi()`:
  - открывает ObjectBox store, создаёт `AnimalsRepo`, выполняет `seedIfEmpty()`
  - поднимает `AppRouter` и `AppRouteObserver`
  - поднимает `ValueNotifier<ThemeMode>` и синхронизирует его с `SharedPreferences`
- **Фильтр типов** находится в энциклопедии:
  - пустой набор типов в prefs = «все типы включены»
  - непустой набор = allow‑list включённых типов

## Запуск

```bash
flutter pub get
flutter run
```

## Генерации (ObjectBox/AutoRoute)

```bash
dart run build_runner build --delete-conflicting-outputs
```

