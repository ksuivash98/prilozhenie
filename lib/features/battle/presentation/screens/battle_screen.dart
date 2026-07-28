import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/core/widgets/reading_challenge_panel.dart';
import 'package:readquest/features/battle/data/enemy_catalog.dart';
import 'package:readquest/features/battle/domain/entities/battle.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/core/services/reading_evaluation_service.dart';

/// Битва, где верно прочитанные слова наносят урон врагу.
class BattleScreen extends ConsumerStatefulWidget {
  const BattleScreen({required this.battleId, super.key});
  final String battleId;

  @override
  ConsumerState<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends ConsumerState<BattleScreen> {
  late Enemy _enemy = EnemyCatalog.byId(widget.battleId);
  int _combo = 0;
  bool _victory = false;

  ReadingChallenge get _challenge => ReadingChallenge(
    id: 'battle_${_enemy.hp}',
    type: ReadingChallengeType.word,
    prompt: 'Прочитай слово — оно станет магическим ударом!',
    targetText: _words[_combo % _words.length],
    difficulty: ChallengeDifficulty.easy,
    wordPower: 8 + _combo,
  );
  static const _words = ['искра', 'радуга', 'дракон', 'приключение'];

  void _hit(ReadingEvaluation evaluation) {
    if (!evaluation.isCorrect || _victory) {
      setState(() => _combo = 0);
      return;
    }
    final damage = BattleState.damageForWord(_challenge.targetText, _combo);
    final hp = (_enemy.hp - damage).clamp(0, _enemy.maxHp).toInt();
    setState(() {
      _combo++;
      _enemy = _enemy.copyWith(currentHp: hp);
      _victory = hp == 0;
    });
    ref.read(gameControllerProvider.notifier).registerReading(
      challenge: _challenge,
      evaluation: evaluation,
      durationMs: 0,
    );
    if (hp == 0) {
      unawaited(
        ref.read(gameControllerProvider.notifier).defeatBoss(
              currentLocationId: _enemy.locationId,
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScreen(
      title: 'Битва слов',
      child: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          QuestCard(
            color: AppColors.ink.withValues(alpha: .88),
            child: Column(children: [
              Text(_victory ? '🎉' : '👾', style: const TextStyle(fontSize: 84)),
              Text(_victory ? 'Победа!' : _enemy.name, style: AppTypography.display(size: 28, color: _victory ? AppColors.magicGold : Colors.white), textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.sm),
              if (!_victory) ...[
                LinearProgressIndicator(value: _enemy.hpRatio, minHeight: 18, color: AppColors.danger, backgroundColor: Colors.white24),
                const SizedBox(height: 6),
                Text('❤️ ${_enemy.hp} / ${_enemy.maxHp} · Комбо ×$_combo', style: AppTypography.label(color: Colors.white)),
              ] else Text(_enemy.defeatText, style: AppTypography.body(color: AppColors.cream), textAlign: TextAlign.center),
            ]),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_victory)
            QuestButton(label: 'Вернуться к карте', icon: Icons.map_rounded, onPressed: () => context.go('/adventure'))
          else
            ReadingChallengePanel(challenge: _challenge, storyBeat: 'Длинные слова дают больше силы!', onResult: _hit),
        ],
      ),
    );
  }
}
