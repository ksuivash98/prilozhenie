import 'package:readquest/features/books/domain/entities/reading_challenge.dart';
import 'package:readquest/features/quests/domain/entities/quest.dart';

/// Стартовые задания, которые превращают чтение в изменения мира.
abstract final class QuestCatalog {
  static const List<Quest> starter = [
    Quest(
      id: 'q_village_bridge',
      title: 'Почини мост слов',
      description: 'Прочитай заклинание, чтобы вернуть доски на старый мост.',
      locationId: 'village',
      npcName: 'Мастер Мостик',
      status: QuestStatus.available,
      storyBeat: 'Каждое верное слово возвращает на мост одну доску!',
      challenges: [
        ReadingChallenge(
          id: 'bridge_word',
          type: ReadingChallengeType.word,
          prompt: 'Прочитай волшебное слово для первой доски',
          targetText: 'мост',
          difficulty: ChallengeDifficulty.starter,
          hint: 'Мост помогает перейти через реку.',
          wordPower: 4,
        ),
        ReadingChallenge(
          id: 'bridge_sentence',
          type: ReadingChallengeType.sentence,
          prompt: 'Прочитай заклинание целиком',
          targetText: 'Мост снова крепкий',
          difficulty: ChallengeDifficulty.easy,
          wordPower: 8,
        ),
      ],
      rewards: [QuestReward(type: QuestRewardType.coins, amount: 12)],
    ),
    Quest(
      id: 'q_village_well',
      title: 'Разбуди колодец',
      description: 'Вода уснула без добрых слов. Верни ей голос.',
      locationId: 'village',
      npcName: 'Бабушка Роса',
      status: QuestStatus.available,
      storyBeat: 'Капли начинают светиться и поднимаются из колодца.',
      challenges: [
        ReadingChallenge(
          id: 'well_word',
          type: ReadingChallengeType.word,
          prompt: 'Прочитай слово-капельку',
          targetText: 'вода',
          difficulty: ChallengeDifficulty.starter,
          wordPower: 4,
        ),
      ],
      rewards: [QuestReward(type: QuestRewardType.xp, amount: 15)],
    ),
    Quest(
      id: 'q_village_library',
      title: 'Фонарь библиотекаря',
      description: 'Зажги фонарь у закрытой библиотеки.',
      locationId: 'village',
      npcName: 'Луми',
      status: QuestStatus.available,
      storyBeat: 'Тёплый свет показывает дорогу к книгам.',
      challenges: [
        ReadingChallenge(
          id: 'library_word',
          type: ReadingChallengeType.word,
          prompt: 'Прочитай ключ к библиотеке',
          targetText: 'книга',
          difficulty: ChallengeDifficulty.easy,
          wordPower: 5,
        ),
      ],
      rewards: [QuestReward(type: QuestRewardType.dragonPart, amount: 1)],
    ),
    Quest(
      id: 'q_forest_path',
      title: 'Тропа из слогов',
      description: 'Листья закрыли дорожку. Найди верный слог.',
      locationId: 'magic_forest',
      npcName: 'Белочка Ива',
      status: QuestStatus.locked,
      storyBeat: 'Листья разлетаются, и лес открывает новую тропу.',
      challenges: [
        ReadingChallenge(
          id: 'forest_syllable',
          type: ReadingChallengeType.syllable,
          prompt: 'Прочитай светящийся слог',
          targetText: 'ли',
          difficulty: ChallengeDifficulty.easy,
          wordPower: 3,
        ),
      ],
      rewards: [QuestReward(type: QuestRewardType.coins, amount: 18)],
    ),
    Quest(
      id: 'q_cave_light',
      title: 'Кристалл эха',
      description: 'Зажги пещерный кристалл звонкой фразой.',
      locationId: 'caves',
      npcName: 'Крот Кварц',
      status: QuestStatus.locked,
      storyBeat: 'Кристалл отвечает эхом и освещает пещеру.',
      challenges: [
        ReadingChallenge(
          id: 'cave_phrase',
          type: ReadingChallengeType.sentence,
          prompt: 'Прочитай фразу для кристалла',
          targetText: 'Свети ярко кристалл',
          difficulty: ChallengeDifficulty.medium,
          wordPower: 10,
        ),
      ],
      rewards: [QuestReward(type: QuestRewardType.item, amount: 1, itemId: 'crystal')],
    ),
  ];

  /// Находит задание по идентификатору.
  static Quest? byId(String id) {
    for (final quest in starter) {
      if (quest.id == id) return quest;
    }
    return null;
  }
}
