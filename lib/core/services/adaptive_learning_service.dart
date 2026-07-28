import 'package:readquest/features/adaptive_learning/domain/entities/adaptive_profile.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';
import 'package:readquest/core/services/reading_evaluation_service.dart';

/// Сервис адаптивного обучения на основе ошибок и скорости.
class AdaptiveLearningService {
  static const int _windowSize = 20;

  final List<bool> _recentResults = [];
  final List<int> _recentSpeeds = [];

  /// Обновляет профиль по результату попытки.
  AdaptiveProfile updateProfile({
    required AdaptiveProfile profile,
    required ReadingChallenge challenge,
    required ReadingEvaluation evaluation,
    required int durationMs,
  }) {
    _recentResults.add(evaluation.isCorrect);
    _recentSpeeds.add(durationMs);
    if (_recentResults.length > _windowSize) {
      _recentResults.removeAt(0);
      _recentSpeeds.removeAt(0);
    }

    final letterRates = Map<String, double>.from(profile.letterErrorRates);
    final syllableRates = Map<String, double>.from(profile.syllableErrorRates);
    final wordRates = Map<String, double>.from(profile.wordErrorRates);

    if (!evaluation.isCorrect) {
      for (final letter in evaluation.errorLetters) {
        letterRates[letter] = (letterRates[letter] ?? 0) + 1;
      }
      for (final syllable in evaluation.errorSyllables) {
        syllableRates[syllable] = (syllableRates[syllable] ?? 0) + 1;
      }
      final word = challenge.normalizedTarget;
      wordRates[word] = (wordRates[word] ?? 0) + 1;
    }

    final accuracy = _recentResults.isEmpty
        ? profile.recentAccuracy
        : _recentResults.where((e) => e).length / _recentResults.length;

    final avgSpeed = _recentSpeeds.isEmpty
        ? profile.averageSpeedMs
        : _recentSpeeds.reduce((a, b) => a + b) / _recentSpeeds.length;

    final difficulty = _recommendDifficulty(accuracy, avgSpeed);
    final level = _recommendLevel(profile.level, accuracy);

    return profile.copyWith(
      level: level,
      averageSpeedMs: avgSpeed,
      letterErrorRates: letterRates,
      syllableErrorRates: syllableRates,
      wordErrorRates: wordRates,
      recentAccuracy: accuracy,
      recommendedDifficulty: difficulty,
    );
  }

  /// Подбирает похожие тренировочные слова по слабым местам.
  List<ReadingChallenge> suggestPractice({
    required AdaptiveProfile profile,
    required List<ReadingChallenge> pool,
    int limit = 5,
  }) {
    final hardLetters = profile.topHardLetters();
    if (hardLetters.isEmpty) {
      return pool
          .where((c) => c.difficulty == profile.recommendedDifficulty)
          .take(limit)
          .toList();
    }

    final scored = pool.map((challenge) {
      final text = challenge.normalizedTarget;
      var score = 0;
      for (final letter in hardLetters) {
        if (text.contains(letter)) score += 2;
      }
      if (challenge.difficulty == profile.recommendedDifficulty) score += 1;
      return (challenge, score);
    }).toList()
      ..sort((a, b) => b.$2.compareTo(a.$2));

    return scored.take(limit).map((e) => e.$1).toList();
  }

  ChallengeDifficulty _recommendDifficulty(double accuracy, double avgSpeed) {
    if (accuracy >= 0.9 && avgSpeed < 2500) return ChallengeDifficulty.hard;
    if (accuracy >= 0.8) return ChallengeDifficulty.medium;
    if (accuracy >= 0.6) return ChallengeDifficulty.easy;
    return ChallengeDifficulty.starter;
  }

  int _recommendLevel(int current, double accuracy) {
    if (accuracy >= 0.9) return (current + 1).clamp(1, 10);
    if (accuracy < 0.45) return (current - 1).clamp(1, 10);
    return current;
  }
}
