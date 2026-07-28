import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:readquest/core/constants/app_routes.dart';
import 'package:readquest/core/di/service_providers.dart';
import 'package:readquest/core/theme/app_colors.dart';
import 'package:readquest/core/theme/app_spacing.dart';
import 'package:readquest/core/theme/app_typography.dart';
import 'package:readquest/core/widgets/game_screen.dart';
import 'package:readquest/core/widgets/quest_button.dart';
import 'package:readquest/features/settings/presentation/providers/settings_providers.dart';

/// Устанавливает или проверяет локальный PIN перед родительским разделом.
class ParentsPinScreen extends ConsumerStatefulWidget {
  const ParentsPinScreen({super.key});
  @override
  ConsumerState<ParentsPinScreen> createState() => _ParentsPinScreenState();
}
class _ParentsPinScreenState extends ConsumerState<ParentsPinScreen> {
  final _pin = TextEditingController();
  String? _error;
  @override void dispose() { _pin.dispose(); super.dispose(); }
  Future<void> _continue() async {
    final value = _pin.text;
    if (!RegExp(r'^\d{4}$').hasMatch(value)) { setState(() => _error = 'Введите ровно 4 цифры.'); return; }
    final settings = ref.read(appSettingsProvider);
    final hash = ref.read(progressStorageProvider).hashPin(value);
    if (!settings.hasParentPin) {
      await ref.read(appSettingsProvider.notifier).setParentPinHash(hash);
    } else if (hash != settings.parentPinHash) {
      setState(() => _error = 'PIN не совпал. Попробуйте ещё раз.');
      return;
    }
    if (mounted) context.go(AppRoutes.parents);
  }
  @override
  Widget build(BuildContext context) {
    final firstTime = !ref.watch(appSettingsProvider).hasParentPin;
    return GameScreen(title: 'Родительский вход', child: Center(child: SingleChildScrollView(padding: AppSpacing.screenPadding, child: QuestCard(child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Text('🔐', style: TextStyle(fontSize: 74)),
      Text(firstTime ? 'Создайте PIN' : 'Введите PIN', style: AppTypography.headline(size: 25)),
      const SizedBox(height: AppSpacing.xs),
      Text(firstTime ? 'Первый вход: придумайте 4 цифры для защиты раздела.' : 'Раздел предназначен для взрослых.', style: AppTypography.body(), textAlign: TextAlign.center),
      const SizedBox(height: AppSpacing.lg),
      TextField(controller: _pin, keyboardType: TextInputType.number, maxLength: 4, obscureText: true, textAlign: TextAlign.center, style: AppTypography.display(size: 30), decoration: InputDecoration(hintText: '••••', errorText: _error, filled: true, fillColor: AppColors.cream, border: OutlineInputBorder(borderRadius: AppSpacing.borderMd))),
      QuestButton(label: firstTime ? 'Сохранить PIN' : 'Открыть раздел', icon: Icons.lock_open_rounded, onPressed: _continue),
    ])))));
  }
}
