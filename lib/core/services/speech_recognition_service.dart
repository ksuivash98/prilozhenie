import 'package:readquest/core/utils/app_logger.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Сервис распознавания речи для проверки чтения вслух.
///
/// Используется как дополнительный канал ввода рядом с текстовым полем.
/// При недоступности микрофона UI остаётся полностью играбельным без него.
class SpeechRecognitionService {
  SpeechRecognitionService() : _speech = SpeechToText();

  final SpeechToText _speech;
  bool _available = false;

  /// Доступно ли распознавание.
  bool get isAvailable => _available;

  /// Инициализирует движок STT.
  Future<bool> init() async {
    try {
      _available = await _speech.initialize(
        onError: (error) => AppLogger.w('STT error: ${error.errorMsg}'),
        onStatus: (status) => AppLogger.d('STT status: $status'),
      );
      return _available;
    } catch (e, st) {
      AppLogger.w('STT init failed', e, st);
      _available = false;
      return false;
    }
  }

  /// Слушает русскую речь и возвращает распознанный текст.
  Future<String?> listen({
    Duration timeout = const Duration(seconds: 6),
  }) async {
    if (!_available) {
      final ok = await init();
      if (!ok) return null;
    }

    var resultText = '';
    await _speech.listen(
      localeId: 'ru_RU',
      listenFor: timeout,
      pauseFor: const Duration(seconds: 2),
      onResult: (result) {
        resultText = result.recognizedWords;
      },
    );

    await Future<void>.delayed(timeout);
    await stop();
    return resultText.trim().isEmpty ? null : resultText.trim();
  }

  /// Останавливает прослушивание.
  Future<void> stop() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }

  /// Освобождает ресурсы.
  Future<void> dispose() async {
    await stop();
    await _speech.cancel();
  }
}
