import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/services/adaptive_learning_service.dart';
import 'package:readquest/core/services/audio_service.dart';
import 'package:readquest/core/services/lumi_service.dart';
import 'package:readquest/core/services/progress_storage_service.dart';
import 'package:readquest/core/services/reading_evaluation_service.dart';
import 'package:readquest/core/services/speech_recognition_service.dart';
import 'package:readquest/core/services/tts_service.dart';
import 'package:readquest/core/services/world_vitality_service.dart';
import 'package:readquest/features/settings/presentation/providers/settings_providers.dart';

/// Provider хранилища прогресса.
final progressStorageProvider = Provider<ProgressStorageService>((ref) {
  return ProgressStorageService();
});

/// Provider TTS.
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  final settings = ref.watch(appSettingsProvider);
  service
    ..setEnabled(settings.ttsEnabled)
    ..init(rate: settings.ttsRate);
  ref.onDispose(service.dispose);
  return service;
});

/// Provider аудио.
final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  final settings = ref.watch(appSettingsProvider);
  service
    ..soundEnabled = settings.soundEnabled
    ..musicEnabled = settings.musicEnabled;
  ref.onDispose(service.dispose);
  return service;
});

/// Provider оценки чтения.
final readingEvaluationServiceProvider =
    Provider<ReadingEvaluationService>((ref) {
  return ReadingEvaluationService();
});

/// Provider живого мира.
final worldVitalityServiceProvider = Provider<WorldVitalityService>((ref) {
  return WorldVitalityService();
});

/// Provider адаптивного обучения.
final adaptiveLearningServiceProvider =
    Provider<AdaptiveLearningService>((ref) {
  return AdaptiveLearningService();
});

/// Provider Луми.
final lumiServiceProvider = Provider<LumiService>((ref) {
  return LumiService();
});

/// Provider распознавания речи.
final speechRecognitionServiceProvider =
    Provider<SpeechRecognitionService>((ref) {
  final service = SpeechRecognitionService();
  ref.onDispose(service.dispose);
  return service;
});
