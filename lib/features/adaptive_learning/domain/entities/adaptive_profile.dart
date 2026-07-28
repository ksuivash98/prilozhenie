import 'package:equatable/equatable.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';

/// Профиль адаптивного обучения.
class AdaptiveProfile extends Equatable {
  const AdaptiveProfile({
    required this.level,
    required this.averageSpeedMs,
    required this.letterErrorRates,
    required this.syllableErrorRates,
    required this.wordErrorRates,
    required this.recentAccuracy,
    required this.recommendedDifficulty,
  });

  /// Уровень 1–10.
  final int level;
  final double averageSpeedMs;
  final Map<String, double> letterErrorRates;
  final Map<String, double> syllableErrorRates;
  final Map<String, double> wordErrorRates;
  final double recentAccuracy;
  final ChallengeDifficulty recommendedDifficulty;

  factory AdaptiveProfile.initial() {
    return const AdaptiveProfile(
      level: 1,
      averageSpeedMs: 3000,
      letterErrorRates: {},
      syllableErrorRates: {},
      wordErrorRates: {},
      recentAccuracy: 1,
      recommendedDifficulty: ChallengeDifficulty.starter,
    );
  }

  AdaptiveProfile copyWith({
    int? level,
    double? averageSpeedMs,
    Map<String, double>? letterErrorRates,
    Map<String, double>? syllableErrorRates,
    Map<String, double>? wordErrorRates,
    double? recentAccuracy,
    ChallengeDifficulty? recommendedDifficulty,
  }) {
    return AdaptiveProfile(
      level: level ?? this.level,
      averageSpeedMs: averageSpeedMs ?? this.averageSpeedMs,
      letterErrorRates: letterErrorRates ?? this.letterErrorRates,
      syllableErrorRates: syllableErrorRates ?? this.syllableErrorRates,
      wordErrorRates: wordErrorRates ?? this.wordErrorRates,
      recentAccuracy: recentAccuracy ?? this.recentAccuracy,
      recommendedDifficulty:
          recommendedDifficulty ?? this.recommendedDifficulty,
    );
  }

  /// Топ сложных букв.
  List<String> topHardLetters({int limit = 5}) {
    final entries = letterErrorRates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return entries.take(limit).map((e) => e.key).toList();
  }

  Map<String, dynamic> toMap() => {
        'level': level,
        'averageSpeedMs': averageSpeedMs,
        'letterErrorRates': letterErrorRates,
        'syllableErrorRates': syllableErrorRates,
        'wordErrorRates': wordErrorRates,
        'recentAccuracy': recentAccuracy,
        'recommendedDifficulty': recommendedDifficulty.name,
      };

  factory AdaptiveProfile.fromMap(Map<dynamic, dynamic> map) {
    return AdaptiveProfile(
      level: map['level'] as int? ?? 1,
      averageSpeedMs: (map['averageSpeedMs'] as num?)?.toDouble() ?? 3000,
      letterErrorRates: Map<String, double>.from(
        (map['letterErrorRates'] as Map<dynamic, dynamic>?)?.map(
              (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
            ) ??
            const {},
      ),
      syllableErrorRates: Map<String, double>.from(
        (map['syllableErrorRates'] as Map<dynamic, dynamic>?)?.map(
              (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
            ) ??
            const {},
      ),
      wordErrorRates: Map<String, double>.from(
        (map['wordErrorRates'] as Map<dynamic, dynamic>?)?.map(
              (k, v) => MapEntry(k.toString(), (v as num).toDouble()),
            ) ??
            const {},
      ),
      recentAccuracy: (map['recentAccuracy'] as num?)?.toDouble() ?? 1,
      recommendedDifficulty: ChallengeDifficulty.values.firstWhere(
        (d) => d.name == map['recommendedDifficulty'],
        orElse: () => ChallengeDifficulty.starter,
      ),
    );
  }

  @override
  List<Object?> get props =>
      [level, averageSpeedMs, recentAccuracy, recommendedDifficulty];
}
