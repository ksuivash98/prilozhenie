import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/config/app_config.dart';
import 'package:readquest/core/navigation/app_router.dart';
import 'package:readquest/core/theme/app_theme.dart';
import 'package:readquest/features/settings/presentation/providers/settings_providers.dart';

/// Корневой виджет приложения ReadQuest.
class ReadQuestApp extends ConsumerWidget {
  const ReadQuestApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final settings = ref.watch(appSettingsProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(
        largeText: settings.largeText,
        highContrast: settings.highContrast,
        openDyslexic: settings.openDyslexic,
        animationSpeed: settings.animationSpeed,
      ),
      darkTheme: AppTheme.highContrast(),
      themeMode: settings.highContrast ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
      locale: const Locale('ru'),
      supportedLocales: const [
        Locale('ru'),
        Locale('en'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
