import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/core/widgets/reading_challenge_panel.dart';
import 'package:readquest/core/constants/game_constants.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';
import 'package:readquest/features/home/presentation/providers/game_providers.dart';
import 'package:readquest/features/mini_games/domain/entities/mini_game.dart';
import 'package:readquest/features/mini_games/games/catch_letter/catch_letter_game.dart';
import 'package:readquest/features/mini_games/games/collect_word/collect_word_game.dart';
import 'package:readquest/features/mini_games/games/defeat_monster/defeat_monster_game.dart';
import 'package:readquest/features/mini_games/games/feed_dragon/feed_dragon_game.dart';
import 'package:readquest/features/mini_games/games/find_item/find_item_game.dart';
import 'package:readquest/features/mini_games/games/farm/farm_game.dart';
import 'package:readquest/features/mini_games/games/fishing/fishing_game.dart';
import 'package:readquest/features/mini_games/games/flying_words/flying_words_game.dart';
import 'package:readquest/features/mini_games/games/forge/forge_game.dart';
import 'package:readquest/features/mini_games/games/knowledge_tower/knowledge_tower_game.dart';
import 'package:readquest/features/mini_games/games/labyrinth/labyrinth_game.dart';
import 'package:readquest/features/mini_games/games/letter_hunt/letter_hunt_game.dart';
import 'package:readquest/features/mini_games/games/library_game/library_game.dart';
import 'package:readquest/features/mini_games/games/magic_forest/magic_forest_game.dart';
import 'package:readquest/features/mini_games/games/magic_runes/magic_runes_game.dart';
import 'package:readquest/features/mini_games/games/open_chest/open_chest_game.dart';
import 'package:readquest/features/mini_games/games/puzzles/puzzles_game.dart';
import 'package:readquest/features/mini_games/games/save_creature/save_creature_game.dart';
import 'package:readquest/features/mini_games/games/ship_voyage/ship_voyage_game.dart';
import 'package:readquest/features/mini_games/games/word_garden/word_garden_game.dart';

/// Хост показывает нужную игру и подтверждает прочтение её слов.
class MiniGameHostScreen extends ConsumerStatefulWidget {
  const MiniGameHostScreen({required this.gameId, super.key});
  final String gameId;
  @override
  ConsumerState<MiniGameHostScreen> createState() => _MiniGameHostScreenState();
}
class _MiniGameHostScreenState extends ConsumerState<MiniGameHostScreen> {
  int _score = 0;
  String _message = 'Готов к раунду?';
  ReadingChallenge? _challenge;

  void _scoreGame(int points, String message) {
    setState(() {
      _score += points;
      _message = message;
    });
  }

  void _needRead(ReadingChallenge challenge) {
    setState(() {
      _challenge = challenge;
      _message = 'Прочитай слово, чтобы закрепить успех.';
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = MiniGameCatalog.byId(widget.gameId) ?? MiniGameCatalog.all.first;
    return GameScreen(title: game.title, child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(color: AppColors.cardWarm, child: Column(children: [
        const Text('🎮', style: TextStyle(fontSize: 56)),
        Text(game.description, style: AppTypography.headline(size: 20), textAlign: TextAlign.center),
        const SizedBox(height: 6),
        Text('Счёт: $_score', style: AppTypography.body()),
      ])),
      const SizedBox(height: AppSpacing.lg),
      _gameBoard(widget.gameId),
      const SizedBox(height: AppSpacing.sm),
      Text(_message, style: AppTypography.label(color: AppColors.cream), textAlign: TextAlign.center),
      if (_challenge != null) ...[
        const SizedBox(height: AppSpacing.lg),
        ReadingChallengePanel(challenge: _challenge!, storyBeat: 'Прочитай слово, чтобы закрепить победу.', onResult: (result) {
          if (!result.isCorrect) return;
          ref.read(gameControllerProvider.notifier).registerReading(challenge: _challenge!, evaluation: result, durationMs: 0);
          setState(() { _score += 5; _message = 'Слово прочитано! +5'; _challenge = null; });
        }),
      ],
    ]));
  }

  Widget _gameBoard(String id) => switch (id) {
    MiniGameIds.feedDragon => FeedDragonGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.collectWord => CollectWordGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.catchLetter => CatchLetterGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.defeatMonster => DefeatMonsterGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.openChest => OpenChestGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.findItem => FindItemGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.fishing => FishingGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.farm => FarmGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.magicForest => MagicForestGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.flyingWords => FlyingWordsGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.puzzles => PuzzlesGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.letterHunt => LetterHuntGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.magicRunes => MagicRunesGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.knowledgeTower => KnowledgeTowerGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.forge => ForgeGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.labyrinth => LabyrinthGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.wordGarden => WordGardenGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.shipVoyage => ShipVoyageGame(onScore: _scoreGame, onNeedRead: _needRead),
    MiniGameIds.saveCreature => SaveCreatureGame(onScore: _scoreGame, onNeedRead: _needRead),
    _ => LibraryGame(onScore: _scoreGame, onNeedRead: _needRead),
  };
}
