import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/services/reading_evaluation_service.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/core/di/service_providers.dart';
import 'package:readquest/features/books/domain/entities/reading_challenge.dart';

/// Универсальный виджет чтения как игровой механики.
class ReadingChallengePanel extends ConsumerStatefulWidget {
  const ReadingChallengePanel({
    required this.challenge,
    required this.onResult,
    super.key,
    this.storyBeat,
  });

  final ReadingChallenge challenge;
  final void Function(ReadingEvaluation evaluation) onResult;
  final String? storyBeat;

  @override
  ConsumerState<ReadingChallengePanel> createState() =>
      _ReadingChallengePanelState();
}

class _ReadingChallengePanelState
    extends ConsumerState<ReadingChallengePanel> {
  final _controller = TextEditingController();
  DateTime? _startedAt;
  String? _feedback;
  bool? _lastSuccess;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _startedAt = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ttsServiceProvider).speak(widget.challenge.prompt);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _listenSpeech() async {
    setState(() => _listening = true);
    final text =
        await ref.read(speechRecognitionServiceProvider).listen();
    if (!mounted) return;
    setState(() => _listening = false);
    if (text != null && text.isNotEmpty) {
      _controller.text = text;
      _submit();
    } else {
      setState(() {
        _feedback = 'Не расслышала. Можно ввести слово руками — ты молодец!';
        _lastSuccess = false;
      });
    }
  }

  void _submit() {
    final evaluation = ref.read(readingEvaluationServiceProvider).evaluate(
          challenge: widget.challenge,
          input: _controller.text,
        );
    final duration =
        DateTime.now().difference(_startedAt ?? DateTime.now()).inMilliseconds;

    setState(() {
      _lastSuccess = evaluation.isCorrect;
      _feedback = evaluation.isCorrect
          ? 'Отлично! Сила слова +${widget.challenge.wordPower}'
          : 'Попробуй ещё раз — у тебя получится!';
      if (evaluation.isCorrect) {
        _startedAt = DateTime.now();
      }
    });

    if (evaluation.isCorrect) {
      ref.read(audioServiceProvider).playSuccess();
      ref.read(ttsServiceProvider).speak('Ура!');
    } else {
      ref.read(lumiServiceProvider).encourage();
    }

    // duration доступен вызывающей стороне через evaluation-пайплайн выше
    debugPrint('Reading duration: $duration ms');
    widget.onResult(evaluation);
  }

  @override
  Widget build(BuildContext context) {
    final challenge = widget.challenge;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.parchment,
        borderRadius: AppSpacing.borderXl,
        border: Border.all(color: AppColors.magicAmber, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.magicGold.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.storyBeat != null) ...[
            Text(
              widget.storyBeat!,
              style: AppTypography.label(color: AppColors.dragonTeal),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          Text(
            challenge.prompt,
            style: AppTypography.headline(size: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cream,
                  AppColors.lumiGlow.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: AppSpacing.borderLg,
            ),
            child: Text(
              challenge.targetText,
              textAlign: TextAlign.center,
              style: AppTypography.reading(size: 34),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    ref.read(ttsServiceProvider).speak(challenge.targetText),
                icon: const Icon(Icons.volume_up_rounded),
                color: AppColors.dragonTeal,
                tooltip: 'Прослушать',
              ),
              IconButton(
                onPressed: _listenSpeech,
                icon: Icon(
                  _listening ? Icons.mic : Icons.mic_none_rounded,
                  color: _listening ? AppColors.dragonCoral : AppColors.inkSoft,
                ),
                tooltip: 'Прочитать вслух',
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  textAlign: TextAlign.center,
                  style: AppTypography.reading(size: 24),
                  decoration: InputDecoration(
                    hintText: 'Введи или повтори',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: AppSpacing.borderMd,
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _submit(),
                ),
              ),
            ],
          ),
          if (challenge.hint != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              challenge.hint!,
              textAlign: TextAlign.center,
              style: AppTypography.body(size: 13),
            ),
          ],
          if (_feedback != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              _feedback!,
              textAlign: TextAlign.center,
              style: AppTypography.label(
                color: _lastSuccess == true
                    ? AppColors.success
                    : AppColors.dragonCoral,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          QuestButton(
            label: 'Готово!',
            icon: Icons.auto_awesome,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
