import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/app/readquest_app.dart';
import 'package:readquest/core/di/app_dependencies.dart';
import 'package:readquest/core/utils/app_logger.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  late final AppDependencies dependencies;
  try {
    dependencies = await AppDependencies.create();
  } catch (error, stackTrace) {
    AppLogger.e('Failed to bootstrap ReadQuest', error, stackTrace);
    rethrow;
  }

  runApp(
    ProviderScope(
      overrides: [
        appDependenciesProvider.overrideWithValue(dependencies),
      ],
      child: const ReadQuestApp(),
    ),
  );
}
