import 'package:equatable/equatable.dart';

/// Дневная статистика чтения.
class DailyReadingStats extends Equatable {
  const DailyReadingStats({
    required this.date,
    required this.wordsRead,
    required this.correctCount,
    required this.errorCount,
    required this.secondsSpent,
    required this.sessionsCount,
  });

  final DateTime date;
  final int wordsRead;
  final int correctCount;
  final int errorCount;
  final int secondsSpent;
  final int sessionsCount;

  double get accuracy {
    final total = correctCount + errorCount;
    if (total == 0) return 1;
    return correctCount / total;
  }

  Map<String, dynamic> toMap() => {
        'date': date.toIso8601String(),
        'wordsRead': wordsRead,
        'correctCount': correctCount,
        'errorCount': errorCount,
        'secondsSpent': secondsSpent,
        'sessionsCount': sessionsCount,
      };

  factory DailyReadingStats.fromMap(Map<dynamic, dynamic> map) {
    return DailyReadingStats(
      date: DateTime.tryParse(map['date'] as String? ?? '') ?? DateTime.now(),
      wordsRead: map['wordsRead'] as int? ?? 0,
      correctCount: map['correctCount'] as int? ?? 0,
      errorCount: map['errorCount'] as int? ?? 0,
      secondsSpent: map['secondsSpent'] as int? ?? 0,
      sessionsCount: map['sessionsCount'] as int? ?? 0,
    );
  }

  DailyReadingStats copyWith({
    int? wordsRead,
    int? correctCount,
    int? errorCount,
    int? secondsSpent,
    int? sessionsCount,
  }) {
    return DailyReadingStats(
      date: date,
      wordsRead: wordsRead ?? this.wordsRead,
      correctCount: correctCount ?? this.correctCount,
      errorCount: errorCount ?? this.errorCount,
      secondsSpent: secondsSpent ?? this.secondsSpent,
      sessionsCount: sessionsCount ?? this.sessionsCount,
    );
  }

  @override
  List<Object?> get props =>
      [date, wordsRead, correctCount, errorCount, secondsSpent];
}

/// Агрегированная статистика для родительского режима.
class ReadingStatistics extends Equatable {
  const ReadingStatistics({
    required this.totalWords,
    required this.totalSeconds,
    required this.totalErrors,
    required this.totalCorrect,
    required this.currentStreak,
    required this.bestStreak,
    required this.daily,
    required this.hardLetters,
    required this.hardSyllables,
    required this.hardWords,
  });

  final int totalWords;
  final int totalSeconds;
  final int totalErrors;
  final int totalCorrect;
  final int currentStreak;
  final int bestStreak;
  final List<DailyReadingStats> daily;
  final Map<String, int> hardLetters;
  final Map<String, int> hardSyllables;
  final Map<String, int> hardWords;

  double get accuracy {
    final total = totalCorrect + totalErrors;
    if (total == 0) return 1;
    return totalCorrect / total;
  }

  double get averageWordsPerMinute {
    if (totalSeconds <= 0) return 0;
    return totalWords / (totalSeconds / 60);
  }

  factory ReadingStatistics.empty() {
    return const ReadingStatistics(
      totalWords: 0,
      totalSeconds: 0,
      totalErrors: 0,
      totalCorrect: 0,
      currentStreak: 0,
      bestStreak: 0,
      daily: [],
      hardLetters: {},
      hardSyllables: {},
      hardWords: {},
    );
  }

  ReadingStatistics copyWith({
    int? totalWords,
    int? totalSeconds,
    int? totalErrors,
    int? totalCorrect,
    int? currentStreak,
    int? bestStreak,
    List<DailyReadingStats>? daily,
    Map<String, int>? hardLetters,
    Map<String, int>? hardSyllables,
    Map<String, int>? hardWords,
  }) {
    return ReadingStatistics(
      totalWords: totalWords ?? this.totalWords,
      totalSeconds: totalSeconds ?? this.totalSeconds,
      totalErrors: totalErrors ?? this.totalErrors,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      daily: daily ?? this.daily,
      hardLetters: hardLetters ?? this.hardLetters,
      hardSyllables: hardSyllables ?? this.hardSyllables,
      hardWords: hardWords ?? this.hardWords,
    );
  }

  Map<String, dynamic> toMap() => {
        'totalWords': totalWords,
        'totalSeconds': totalSeconds,
        'totalErrors': totalErrors,
        'totalCorrect': totalCorrect,
        'currentStreak': currentStreak,
        'bestStreak': bestStreak,
        'daily': daily.map((e) => e.toMap()).toList(),
        'hardLetters': hardLetters,
        'hardSyllables': hardSyllables,
        'hardWords': hardWords,
      };

  factory ReadingStatistics.fromMap(Map<dynamic, dynamic> map) {
    final dailyRaw = map['daily'] as List<dynamic>? ?? const [];
    return ReadingStatistics(
      totalWords: map['totalWords'] as int? ?? 0,
      totalSeconds: map['totalSeconds'] as int? ?? 0,
      totalErrors: map['totalErrors'] as int? ?? 0,
      totalCorrect: map['totalCorrect'] as int? ?? 0,
      currentStreak: map['currentStreak'] as int? ?? 0,
      bestStreak: map['bestStreak'] as int? ?? 0,
      daily: dailyRaw
          .map((e) => DailyReadingStats.fromMap(e as Map<dynamic, dynamic>))
          .toList(),
      hardLetters: Map<String, int>.from(
        (map['hardLetters'] as Map<dynamic, dynamic>?) ?? const {},
      ),
      hardSyllables: Map<String, int>.from(
        (map['hardSyllables'] as Map<dynamic, dynamic>?) ?? const {},
      ),
      hardWords: Map<String, int>.from(
        (map['hardWords'] as Map<dynamic, dynamic>?) ?? const {},
      ),
    );
  }

  @override
  List<Object?> get props => [
        totalWords,
        totalSeconds,
        totalErrors,
        totalCorrect,
        currentStreak,
        bestStreak,
        daily,
      ];
}
