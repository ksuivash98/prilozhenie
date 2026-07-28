import 'package:equatable/equatable.dart';
import 'package:readquest/core/constants/game_constants.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';

/// Метаданные мини-игры.
class MiniGameInfo extends Equatable {
  const MiniGameInfo({
    required this.id,
    required this.title,
    required this.description,
    required this.mechanic,
    required this.unlockWords,
    required this.isUnlocked,
    this.bestScore = 0,
  });

  final String id;
  final String title;
  final String description;

  /// Краткое описание уникальной механики.
  final String mechanic;
  final int unlockWords;
  final bool isUnlocked;
  final int bestScore;

  MiniGameInfo copyWith({bool? isUnlocked, int? bestScore}) {
    return MiniGameInfo(
      id: id,
      title: title,
      description: description,
      mechanic: mechanic,
      unlockWords: unlockWords,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      bestScore: bestScore ?? this.bestScore,
    );
  }

  @override
  List<Object?> get props => [id, title, isUnlocked, bestScore];
}

/// Каталог 20 мини-игр.
abstract final class MiniGameCatalog {
  static const List<MiniGameInfo> all = [
    MiniGameInfo(
      id: MiniGameIds.feedDragon,
      title: 'Накорми дракона',
      description: 'Прочитай название еды — дракон её съест.',
      mechanic: 'word_to_feed',
      unlockWords: 0,
      isUnlocked: true,
    ),
    MiniGameInfo(
      id: MiniGameIds.collectWord,
      title: 'Собери слово',
      description: 'Расставь буквы в правильном порядке.',
      mechanic: 'letter_order',
      unlockWords: 5,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.catchLetter,
      title: 'Поймай букву',
      description: 'Лови падающие буквы нужного слова.',
      mechanic: 'falling_catch',
      unlockWords: 10,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.defeatMonster,
      title: 'Победи монстра',
      description: 'Читай слова, чтобы бить монстра.',
      mechanic: 'read_to_damage',
      unlockWords: 15,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.openChest,
      title: 'Открой сундук',
      description: 'Прочитай пароль сундука.',
      mechanic: 'password_read',
      unlockWords: 20,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.findItem,
      title: 'Найди предмет',
      description: 'Прочитай подсказку и найди спрятанный предмет.',
      mechanic: 'clue_search',
      unlockWords: 25,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.fishing,
      title: 'Рыбалка',
      description: 'Выуди буквы и собери слово.',
      mechanic: 'reel_letters',
      unlockWords: 35,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.farm,
      title: 'Ферма',
      description: 'Посади слоги и собери урожай-слово.',
      mechanic: 'grow_syllables',
      unlockWords: 45,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.magicForest,
      title: 'Магический лес',
      description: 'Освети тропу правильными словами.',
      mechanic: 'path_light',
      unlockWords: 55,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.flyingWords,
      title: 'Летающие слова',
      description: 'Коснись нужного слова среди летающих.',
      mechanic: 'tap_flying',
      unlockWords: 65,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.puzzles,
      title: 'Пазлы',
      description: 'Собери картинку, читая подписи частей.',
      mechanic: 'puzzle_labels',
      unlockWords: 75,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.letterHunt,
      title: 'Поиск букв',
      description: 'Найди все буквы слова на сцене.',
      mechanic: 'scene_hunt',
      unlockWords: 85,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.magicRunes,
      title: 'Магические руны',
      description: 'Активируй руны в порядке чтения.',
      mechanic: 'rune_sequence',
      unlockWords: 100,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.knowledgeTower,
      title: 'Башня знаний',
      description: 'Поднимайся этаж за этажом, читая всё сложнее.',
      mechanic: 'tower_climb',
      unlockWords: 120,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.forge,
      title: 'Кузница',
      description: 'Выкуй меч из слогов.',
      mechanic: 'forge_syllables',
      unlockWords: 140,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.labyrinth,
      title: 'Лабиринт',
      description: 'Выбери верный поворот, читая указатели.',
      mechanic: 'maze_signs',
      unlockWords: 160,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.wordGarden,
      title: 'Сад слов',
      description: 'Полей цветы правильными словами.',
      mechanic: 'water_words',
      unlockWords: 180,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.shipVoyage,
      title: 'Путешествие на корабле',
      description: 'Направляй корабль флагами-словами.',
      mechanic: 'sail_flags',
      unlockWords: 200,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.saveCreature,
      title: 'Спаси зверька',
      description: 'Освободи зверка, прочитав заклинание.',
      mechanic: 'spell_rescue',
      unlockWords: 220,
      isUnlocked: false,
    ),
    MiniGameInfo(
      id: MiniGameIds.libraryGame,
      title: 'Библиотека',
      description: 'Расставь книги по прочитанным названиям.',
      mechanic: 'shelf_sort',
      unlockWords: 250,
      isUnlocked: false,
    ),
  ];

  static MiniGameInfo? byId(String id) {
    for (final g in all) {
      if (g.id == id) return g;
    }
    return null;
  }
}

/// Результат раунда мини-игры.
class MiniGameResult extends Equatable {
  const MiniGameResult({
    required this.gameId,
    required this.score,
    required this.wordsCompleted,
    required this.success,
    required this.xpGained,
    this.difficulty = ChallengeDifficulty.easy,
  });

  final String gameId;
  final int score;
  final int wordsCompleted;
  final bool success;
  final int xpGained;
  final ChallengeDifficulty difficulty;

  @override
  List<Object?> get props => [gameId, score, wordsCompleted, success];
}
