import 'package:equatable/equatable.dart';

/// Тип чтения, необходимого для действия.
enum ReadingChallengeType {
  letter,
  syllable,
  word,
  sentence,
  paragraph,
  story,
}

/// Сложность задания.
enum ChallengeDifficulty {
  starter,
  easy,
  medium,
  hard,
  expert,
}

/// Игровое чтение-вызов: механика «прочитай → получи эффект».
class ReadingChallenge extends Equatable {
  const ReadingChallenge({
    required this.id,
    required this.type,
    required this.prompt,
    required this.targetText,
    required this.difficulty,
    this.hint,
    this.acceptedVariants = const [],
    this.xpReward = 10,
    this.wordPower = 1,
  });

  final String id;
  final ReadingChallengeType type;

  /// Подсказка для ребёнка (что сделать).
  final String prompt;

  /// Текст, который нужно прочитать.
  final String targetText;
  final ChallengeDifficulty difficulty;
  final String? hint;

  /// Допустимые варианты произношения/ввода.
  final List<String> acceptedVariants;
  final int xpReward;

  /// Сила удара / эффекта (длиннее слово → сильнее).
  final int wordPower;

  /// Нормализованный целевой текст.
  String get normalizedTarget =>
      targetText.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

  /// Проверяет ответ ребёнка.
  bool matches(String input) {
    final normalized = input.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    if (normalized == normalizedTarget) return true;
    return acceptedVariants.any(
      (v) => v.trim().toLowerCase() == normalized,
    );
  }

  @override
  List<Object?> get props =>
      [id, type, prompt, targetText, difficulty, xpReward, wordPower];
}

/// Результат попытки чтения.
class ReadingAttempt extends Equatable {
  const ReadingAttempt({
    required this.challengeId,
    required this.input,
    required this.isCorrect,
    required this.durationMs,
    required this.timestamp,
    this.errorLetters = const [],
    this.errorSyllables = const [],
  });

  final String challengeId;
  final String input;
  final bool isCorrect;
  final int durationMs;
  final DateTime timestamp;
  final List<String> errorLetters;
  final List<String> errorSyllables;

  Map<String, dynamic> toMap() => {
        'challengeId': challengeId,
        'input': input,
        'isCorrect': isCorrect,
        'durationMs': durationMs,
        'timestamp': timestamp.toIso8601String(),
        'errorLetters': errorLetters,
        'errorSyllables': errorSyllables,
      };

  factory ReadingAttempt.fromMap(Map<dynamic, dynamic> map) {
    return ReadingAttempt(
      challengeId: map['challengeId'] as String? ?? '',
      input: map['input'] as String? ?? '',
      isCorrect: map['isCorrect'] as bool? ?? false,
      durationMs: map['durationMs'] as int? ?? 0,
      timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ??
          DateTime.now(),
      errorLetters:
          (map['errorLetters'] as List<dynamic>?)?.cast<String>() ?? const [],
      errorSyllables:
          (map['errorSyllables'] as List<dynamic>?)?.cast<String>() ?? const [],
    );
  }

  @override
  List<Object?> get props =>
      [challengeId, input, isCorrect, durationMs, timestamp];
}
