import 'package:readquest/features/books/domain/entities/reading_challenge.dart';

/// Результат оценки чтения.
class ReadingEvaluation {
  const ReadingEvaluation({
    required this.isCorrect,
    required this.similarity,
    required this.errorLetters,
    required this.errorSyllables,
    required this.normalizedInput,
  });

  final bool isCorrect;
  final double similarity;
  final List<String> errorLetters;
  final List<String> errorSyllables;
  final String normalizedInput;
}

/// Сервис оценки ответов ребёнка при чтении.
///
/// Учитывает регистр, пробелы и допустимые варианты.
/// Для адаптивного обучения собирает буквы/слоги с ошибками.
class ReadingEvaluationService {
  /// Нормализует текст для сравнения.
  String normalize(String input) {
    return input
        .trim()
        .toLowerCase()
        .replaceAll('ё', 'е')
        .replaceAll(RegExp(r'[^а-яА-ЯёЁa-zA-Z0-9\s]'), '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Оценивает [input] относительно [challenge].
  ReadingEvaluation evaluate({
    required ReadingChallenge challenge,
    required String input,
  }) {
    final normalizedInput = normalize(input);
    final target = normalize(challenge.targetText);

    if (challenge.matches(normalizedInput) || normalizedInput == target) {
      return ReadingEvaluation(
        isCorrect: true,
        similarity: 1,
        errorLetters: const [],
        errorSyllables: const [],
        normalizedInput: normalizedInput,
      );
    }

    for (final variant in challenge.acceptedVariants) {
      if (normalize(variant) == normalizedInput) {
        return ReadingEvaluation(
          isCorrect: true,
          similarity: 1,
          errorLetters: const [],
          errorSyllables: const [],
          normalizedInput: normalizedInput,
        );
      }
    }

    final similarity = _similarity(normalizedInput, target);
    final errorLetters = _diffLetters(normalizedInput, target);
    final errorSyllables = _guessSyllables(target)
        .where((s) => !normalizedInput.contains(s))
        .toList();

    // Мягкий порог для очень похожих ответов младших детей.
    final softPass = similarity >= 0.85 &&
        challenge.type != ReadingChallengeType.letter;

    return ReadingEvaluation(
      isCorrect: softPass,
      similarity: similarity,
      errorLetters: errorLetters,
      errorSyllables: errorSyllables,
      normalizedInput: normalizedInput,
    );
  }

  double _similarity(String a, String b) {
    if (a.isEmpty && b.isEmpty) return 1;
    if (a.isEmpty || b.isEmpty) return 0;
    final distance = _levenshtein(a, b);
    final maxLen = a.length > b.length ? a.length : b.length;
    return 1 - (distance / maxLen);
  }

  int _levenshtein(String s, String t) {
    final m = s.length;
    final n = t.length;
    final dp = List.generate(m + 1, (_) => List<int>.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      dp[0][j] = j;
    }
    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        final cost = s[i - 1] == t[j - 1] ? 0 : 1;
        dp[i][j] = [
          dp[i - 1][j] + 1,
          dp[i][j - 1] + 1,
          dp[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }
    return dp[m][n];
  }

  List<String> _diffLetters(String input, String target) {
    final result = <String>[];
    final max = target.length > input.length ? target.length : input.length;
    for (var i = 0; i < max; i++) {
      final t = i < target.length ? target[i] : null;
      final inp = i < input.length ? input[i] : null;
      if (t != null && t != inp && RegExp(r'[а-яa-z]', caseSensitive: false).hasMatch(t)) {
        result.add(t);
      }
    }
    return result.toSet().toList();
  }

  List<String> _guessSyllables(String word) {
    // Упрощённая сегментация для русского: гласные как ядра слогов.
    const vowels = 'аеёиоуыэюяaeiouy';
    final syllables = <String>[];
    final buffer = StringBuffer();
    for (var i = 0; i < word.length; i++) {
      buffer.write(word[i]);
      final isVowel = vowels.contains(word[i]);
      final nextIsConsonant = i + 1 < word.length && !vowels.contains(word[i + 1]);
      if (isVowel && nextIsConsonant) {
        syllables.add(buffer.toString());
        buffer.clear();
      }
    }
    if (buffer.isNotEmpty) syllables.add(buffer.toString());
    return syllables.where((s) => s.length >= 2).toList();
  }
}
