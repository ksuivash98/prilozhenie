import 'package:flutter_test/flutter_test.dart';
import 'package:readquest/core/services/reading_evaluation_service.dart';
import 'package:readquest/core/services/world_vitality_service.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';
import 'package:readquest/features/battle/domain/entities/battle.dart';
import 'package:readquest/features/world/domain/entities/world_state.dart';

void main() {
  group('ReadingEvaluationService', () {
    final service = ReadingEvaluationService();

    test('принимает точное совпадение слова', () {
      const challenge = ReadingChallenge(
        id: 't1',
        type: ReadingChallengeType.word,
        prompt: 'Прочитай',
        targetText: 'мост',
        difficulty: ChallengeDifficulty.starter,
      );
      final result = service.evaluate(challenge: challenge, input: 'Мост');
      expect(result.isCorrect, isTrue);
    });

    test('отклоняет сильно отличающийся ответ', () {
      const challenge = ReadingChallenge(
        id: 't2',
        type: ReadingChallengeType.word,
        prompt: 'Прочитай',
        targetText: 'радуга',
        difficulty: ChallengeDifficulty.easy,
      );
      final result = service.evaluate(challenge: challenge, input: 'камень');
      expect(result.isCorrect, isFalse);
      expect(result.similarity < 0.5, isTrue);
    });
  });

  group('BattleState', () {
    test('длинное слово наносит больший урон', () {
      final short = BattleState.damageForWord('кот', 0);
      final long = BattleState.damageForWord('приключение', 0);
      expect(long > short, isTrue);
    });
  });

  group('WorldVitalityService', () {
    test('чтение повышает vitality', () {
      final service = WorldVitalityService();
      final before = WorldState.initial();
      final after = service.onWordsRead(before, 5);
      expect(after.vitalityScore > before.vitalityScore, isTrue);
      expect(after.totalWordsRead, before.totalWordsRead + 5);
    });
  });
}
