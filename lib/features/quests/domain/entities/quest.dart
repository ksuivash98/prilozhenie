import 'package:equatable/equatable.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';

/// Статус квеста.
enum QuestStatus { locked, available, active, completed }

/// Тип награды квеста.
enum QuestRewardType { xp, coins, item, dragonPart, building, story }

/// Награда за квест.
class QuestReward extends Equatable {
  const QuestReward({
    required this.type,
    required this.amount,
    this.itemId,
  });

  final QuestRewardType type;
  final int amount;
  final String? itemId;

  Map<String, dynamic> toMap() => {
        'type': type.name,
        'amount': amount,
        'itemId': itemId,
      };

  factory QuestReward.fromMap(Map<dynamic, dynamic> map) {
    return QuestReward(
      type: QuestRewardType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => QuestRewardType.xp,
      ),
      amount: map['amount'] as int? ?? 0,
      itemId: map['itemId'] as String?,
    );
  }

  @override
  List<Object?> get props => [type, amount, itemId];
}

/// Квест приключения.
class Quest extends Equatable {
  const Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.locationId,
    required this.npcName,
    required this.status,
    required this.challenges,
    required this.rewards,
    required this.storyBeat,
    this.progressIndex = 0,
  });

  final String id;
  final String title;
  final String description;
  final String locationId;
  final String npcName;
  final QuestStatus status;
  final List<ReadingChallenge> challenges;
  final List<QuestReward> rewards;

  /// Сюжетный эффект: «прочитай → почини мост».
  final String storyBeat;
  final int progressIndex;

  /// Завершён ли квест.
  bool get isCompleted => status == QuestStatus.completed;

  /// Текущий челлендж или null.
  ReadingChallenge? get currentChallenge {
    if (progressIndex < 0 || progressIndex >= challenges.length) return null;
    return challenges[progressIndex];
  }

  double get progress =>
      challenges.isEmpty ? 0 : progressIndex / challenges.length;

  Quest copyWith({
    QuestStatus? status,
    int? progressIndex,
  }) {
    return Quest(
      id: id,
      title: title,
      description: description,
      locationId: locationId,
      npcName: npcName,
      status: status ?? this.status,
      challenges: challenges,
      rewards: rewards,
      storyBeat: storyBeat,
      progressIndex: progressIndex ?? this.progressIndex,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, locationId, status, progressIndex, storyBeat];
}
