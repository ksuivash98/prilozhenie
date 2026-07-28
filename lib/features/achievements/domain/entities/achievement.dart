import 'package:equatable/equatable.dart';

/// Редкость достижения / предмета.
enum Rarity { common, uncommon, rare, epic, legendary }

/// Достижение.
class Achievement extends Equatable {
  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.rarity,
    required this.targetValue,
    required this.currentValue,
    required this.isUnlocked,
    this.unlockedAt,
    this.iconKey = 'star',
  });

  final String id;
  final String title;
  final String description;
  final Rarity rarity;
  final int targetValue;
  final int currentValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final String iconKey;

  double get progress =>
      targetValue <= 0 ? 1 : (currentValue / targetValue).clamp(0.0, 1.0);

  Achievement copyWith({
    int? currentValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
  }) {
    return Achievement(
      id: id,
      title: title,
      description: description,
      rarity: rarity,
      targetValue: targetValue,
      currentValue: currentValue ?? this.currentValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      iconKey: iconKey,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'currentValue': currentValue,
        'isUnlocked': isUnlocked,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props =>
      [id, title, rarity, currentValue, isUnlocked, targetValue];
}

/// Каталог достижений.
abstract final class AchievementCatalog {
  static List<Achievement> seed() => const [
        Achievement(
          id: 'first_word',
          title: 'Первое слово',
          description: 'Прочитай своё первое слово и зажги искру мира.',
          rarity: Rarity.common,
          targetValue: 1,
          currentValue: 0,
          isUnlocked: false,
          iconKey: 'spark',
        ),
        Achievement(
          id: 'words_50',
          title: 'Собиратель слов',
          description: 'Прочитай 50 слов.',
          rarity: Rarity.uncommon,
          targetValue: 50,
          currentValue: 0,
          isUnlocked: false,
        ),
        Achievement(
          id: 'words_200',
          title: 'Хранитель сказаний',
          description: 'Прочитай 200 слов.',
          rarity: Rarity.rare,
          targetValue: 200,
          currentValue: 0,
          isUnlocked: false,
        ),
        Achievement(
          id: 'dragon_hatch',
          title: 'Рождение дракона',
          description: 'Вылупи дракона из яйца.',
          rarity: Rarity.rare,
          targetValue: 1,
          currentValue: 0,
          isUnlocked: false,
          iconKey: 'egg',
        ),
        Achievement(
          id: 'first_boss',
          title: 'Победитель тьмы',
          description: 'Победи первого босса.',
          rarity: Rarity.epic,
          targetValue: 1,
          currentValue: 0,
          isUnlocked: false,
          iconKey: 'sword',
        ),
        Achievement(
          id: 'streak_7',
          title: 'Неделя приключений',
          description: 'Читай 7 дней подряд.',
          rarity: Rarity.epic,
          targetValue: 7,
          currentValue: 0,
          isUnlocked: false,
          iconKey: 'flame',
        ),
        Achievement(
          id: 'city_castle',
          title: 'Зодчий замка',
          description: 'Открой замок в своём городе.',
          rarity: Rarity.legendary,
          targetValue: 1,
          currentValue: 0,
          isUnlocked: false,
          iconKey: 'castle',
        ),
        Achievement(
          id: 'all_locations',
          title: 'Путешественник миров',
          description: 'Открой все локации.',
          rarity: Rarity.legendary,
          targetValue: 10,
          currentValue: 0,
          isUnlocked: false,
          iconKey: 'map',
        ),
      ];
}
