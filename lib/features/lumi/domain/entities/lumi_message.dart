import 'package:equatable/equatable.dart';

/// Тон сообщения Луми — только позитивная мотивация.
enum LumiTone {
  greet,
  encourage,
  celebrate,
  hint,
  guide,
  comfort,
}

/// Сообщение ИИ-помощника Луми.
class LumiMessage extends Equatable {
  const LumiMessage({
    required this.id,
    required this.text,
    required this.tone,
    this.animationKey = 'idle',
  });

  final String id;
  final String text;
  final LumiTone tone;
  final String animationKey;

  @override
  List<Object?> get props => [id, text, tone, animationKey];
}

/// Каталог реплик Луми (правило: никогда не критиковать).
abstract final class LumiCatalog {
  static const List<LumiMessage> greetings = [
    LumiMessage(
      id: 'greet_1',
      text: 'Привет! Я Луми. Давай вместе вернём силу слов!',
      tone: LumiTone.greet,
      animationKey: 'wave',
    ),
    LumiMessage(
      id: 'greet_2',
      text: 'Рада тебя видеть! Мир уже ждёт твоих слов.',
      tone: LumiTone.greet,
      animationKey: 'sparkle',
    ),
  ];

  static const List<LumiMessage> encouragements = [
    LumiMessage(
      id: 'enc_1',
      text: 'Ты справишься! Попробуй ещё раз — я рядом.',
      tone: LumiTone.encourage,
    ),
    LumiMessage(
      id: 'enc_2',
      text: 'Каждая попытка делает тебя сильнее. Вперёд!',
      tone: LumiTone.encourage,
    ),
    LumiMessage(
      id: 'enc_3',
      text: 'Дыши спокойно. Слово само придёт к тебе.',
      tone: LumiTone.comfort,
    ),
  ];

  static const List<LumiMessage> celebrations = [
    LumiMessage(
      id: 'cel_1',
      text: 'Ура! Ты прочитал это слово — мир стал ярче!',
      tone: LumiTone.celebrate,
      animationKey: 'celebrate',
    ),
    LumiMessage(
      id: 'cel_2',
      text: 'Потрясающе! Дракон гордится тобой!',
      tone: LumiTone.celebrate,
      animationKey: 'celebrate',
    ),
    LumiMessage(
      id: 'cel_3',
      text: 'Волшебно! Ещё одно слово вернулось домой.',
      tone: LumiTone.celebrate,
      animationKey: 'sparkle',
    ),
  ];

  static const List<LumiMessage> guides = [
    LumiMessage(
      id: 'guide_1',
      text: 'Прочитай слово вслух — и мост починится!',
      tone: LumiTone.guide,
    ),
    LumiMessage(
      id: 'guide_2',
      text: 'Чем длиннее слово, тем сильнее удар по монстру.',
      tone: LumiTone.hint,
    ),
    LumiMessage(
      id: 'guide_3',
      text: 'Нажми на буквы по порядку, чтобы собрать слово.',
      tone: LumiTone.hint,
    ),
  ];

  /// Выбирает сообщение по тону.
  static LumiMessage pick(LumiTone tone, {int seed = 0}) {
    final list = switch (tone) {
      LumiTone.greet => greetings,
      LumiTone.encourage || LumiTone.comfort => encouragements,
      LumiTone.celebrate => celebrations,
      LumiTone.hint || LumiTone.guide => guides,
    };
    return list[seed % list.length];
  }
}
