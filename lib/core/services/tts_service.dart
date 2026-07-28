import 'package:flutter_tts/flutter_tts.dart';
import 'package:readquest/core/utils/app_logger.dart';

/// Сервис озвучивания текста для детей.
class TtsService {
  TtsService() : _tts = FlutterTts();

  final FlutterTts _tts;
  bool _ready = false;
  double _rate = 0.45;
  bool _enabled = true;

  /// Инициализирует TTS (русский язык).
  Future<void> init({double rate = 0.45}) async {
    _rate = rate;
    try {
      await _tts.setLanguage('ru-RU');
      await _tts.setSpeechRate(_rate);
      await _tts.setVolume(1);
      await _tts.setPitch(1.05);
      _ready = true;
    } catch (e, st) {
      AppLogger.w('TTS init failed', e, st);
      _ready = false;
    }
  }

  /// Включает / выключает озвучку.
  void setEnabled(bool value) => _enabled = value;

  /// Обновляет скорость речи.
  Future<void> setRate(double rate) async {
    _rate = rate.clamp(0.2, 0.8);
    if (_ready) await _tts.setSpeechRate(_rate);
  }

  /// Произносит [text].
  Future<void> speak(String text) async {
    if (!_enabled || !_ready || text.trim().isEmpty) return;
    await _tts.stop();
    await _tts.speak(text);
  }

  /// Останавливает речь.
  Future<void> stop() async {
    if (_ready) await _tts.stop();
  }

  /// Освобождает ресурсы.
  Future<void> dispose() async {
    await stop();
  }
}
