import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/features/settings/presentation/providers/settings_providers.dart';

/// Настройки звука, текста, контраста и анимаций для доступного чтения.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    return GameScreen(title: 'Настройки', child: ListView(padding: AppSpacing.screenPadding, children: [
      QuestCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Звук', style: AppTypography.headline(size: 21)),
        SwitchListTile(value: settings.soundEnabled, onChanged: notifier.setSoundEnabled, title: const Text('Звуки игры'), secondary: const Icon(Icons.volume_up_rounded)),
        SwitchListTile(value: settings.musicEnabled, onChanged: notifier.setMusicEnabled, title: const Text('Музыка'), secondary: const Icon(Icons.music_note_rounded)),
        SwitchListTile(value: settings.ttsEnabled, onChanged: notifier.setTtsEnabled, title: const Text('Озвучивание текста'), secondary: const Icon(Icons.record_voice_over_rounded)),
      ])),
      const SizedBox(height: AppSpacing.md),
      QuestCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Доступность', style: AppTypography.headline(size: 21)),
        SwitchListTile(value: settings.largeText, onChanged: notifier.setLargeText, title: const Text('Крупный текст'), secondary: const Icon(Icons.format_size_rounded)),
        SwitchListTile(value: settings.highContrast, onChanged: notifier.setHighContrast, title: const Text('Высокий контраст'), secondary: const Icon(Icons.contrast_rounded)),
        SwitchListTile(value: settings.openDyslexic, onChanged: notifier.setOpenDyslexic, title: const Text('Шрифт для удобного чтения'), secondary: const Icon(Icons.menu_book_rounded)),
      ])),
      const SizedBox(height: AppSpacing.md),
      QuestCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Скорость анимаций', style: AppTypography.headline(size: 21)),
        Slider(value: settings.animationSpeed, min: .5, max: 1.5, divisions: 4, activeColor: AppColors.dragonTeal, label: '${settings.animationSpeed}×', onChanged: notifier.setAnimationSpeed),
      ])),
    ]));
  }
}
