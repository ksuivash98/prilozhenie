import 'package:equatable/equatable.dart';

/// Рассказ в библиотеке.
class Story extends Equatable {
  const Story({
    required this.id,
    required this.title,
    required this.pages,
    required this.illustrationKeys,
    required this.isRead,
    required this.unlockedIllustrations,
    this.locationId,
    this.wordsCount = 0,
  });

  final String id;
  final String title;
  final List<String> pages;
  final List<String> illustrationKeys;
  final bool isRead;
  final Set<String> unlockedIllustrations;
  final String? locationId;
  final int wordsCount;

  Story copyWith({
    bool? isRead,
    Set<String>? unlockedIllustrations,
  }) {
    return Story(
      id: id,
      title: title,
      pages: pages,
      illustrationKeys: illustrationKeys,
      isRead: isRead ?? this.isRead,
      unlockedIllustrations:
          unlockedIllustrations ?? this.unlockedIllustrations,
      locationId: locationId,
      wordsCount: wordsCount,
    );
  }

  @override
  List<Object?> get props => [id, title, isRead, unlockedIllustrations];
}

/// Каталог стартовых рассказов.
abstract final class StoryCatalog {
  static List<Story> seed() => const [
        Story(
          id: 'story_village_dawn',
          title: 'Утро в Деревне Слов',
          pages: [
            'В деревне погас свет слов.',
            'Маленький герой нашёл яйцо дракона.',
            'Луми сказала: «Читай — и мир оживёт!»',
            'Первое слово зажгло фонарь у моста.',
          ],
          illustrationKeys: ['ill_village_1', 'ill_village_2', 'ill_egg', 'ill_lamp'],
          isRead: false,
          unlockedIllustrations: {},
          locationId: 'village',
          wordsCount: 28,
        ),
        Story(
          id: 'story_forest_whisper',
          title: 'Шёпот леса',
          pages: [
            'Волшебный лес потерял голос.',
            'Белка показала тропу из слогов.',
            'Герой прочитал «лиса» — и лиса вышла из тумана.',
            'Деревья зашелестели благодарностью.',
          ],
          illustrationKeys: ['ill_forest_1', 'ill_path', 'ill_fox', 'ill_trees'],
          isRead: false,
          unlockedIllustrations: {},
          locationId: 'magic_forest',
          wordsCount: 32,
        ),
        Story(
          id: 'story_devourer_shadow',
          title: 'Тень Пожирателя',
          pages: [
            'Далеко в космосе ждал Пожиратель Букв.',
            'Он прятал книги в чёрных облаках.',
            'Но каждое прочитанное слово делало тьму слабее.',
            'Дракон вздохнул огнём надежды.',
          ],
          illustrationKeys: ['ill_space', 'ill_clouds', 'ill_light', 'ill_dragon'],
          isRead: false,
          unlockedIllustrations: {},
          locationId: 'cosmos',
          wordsCount: 36,
        ),
      ];
}
