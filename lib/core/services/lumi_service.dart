import 'package:readquest/features/lumi/domain/entities/lumi_message.dart';

/// Сервис ИИ-помощника Луми.
///
/// Правило продукта: только позитивная мотивация, без критики.
class LumiService {
  var _seed = 0;

  /// Приветствие при входе.
  LumiMessage greet({String? playerName}) {
    final base = LumiCatalog.pick(LumiTone.greet, seed: _seed++);
    if (playerName == null || playerName.isEmpty) return base;
    return LumiMessage(
      id: '${base.id}_named',
      text: 'Привет, $playerName! ${base.text}',
      tone: base.tone,
      animationKey: base.animationKey,
    );
  }

  /// Поддержка после ошибки — без негатива.
  LumiMessage encourage() =>
      LumiCatalog.pick(LumiTone.encourage, seed: _seed++);

  /// Празднование успеха.
  LumiMessage celebrate() =>
      LumiCatalog.pick(LumiTone.celebrate, seed: _seed++);

  /// Подсказка к заданию.
  LumiMessage guide({String? custom}) {
    if (custom != null && custom.isNotEmpty) {
      return LumiMessage(
        id: 'custom_guide_$_seed',
        text: custom,
        tone: LumiTone.guide,
      );
    }
    return LumiCatalog.pick(LumiTone.guide, seed: _seed++);
  }

  /// Сообщение о состоянии мира.
  LumiMessage worldStatus(double vitality) {
    if (vitality >= 0.8) {
      return const LumiMessage(
        id: 'world_thriving',
        text: 'Смотри, как мир сияет! Твои слова творят чудеса!',
        tone: LumiTone.celebrate,
        animationKey: 'sparkle',
      );
    }
    if (vitality >= 0.45) {
      return const LumiMessage(
        id: 'world_alive',
        text: 'Мир живёт благодаря тебе. Давай прочитаем ещё немного?',
        tone: LumiTone.encourage,
      );
    }
    return const LumiMessage(
      id: 'world_fading',
      text: 'Миру немного грустно без слов. Одно слово — и краски вернутся!',
      tone: LumiTone.comfort,
    );
  }
}
