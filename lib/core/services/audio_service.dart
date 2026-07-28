import 'package:audioplayers/audioplayers.dart';
import 'package:just_audio/just_audio.dart' as ja;
import 'package:readquest/core/utils/app_logger.dart';

/// Сервис музыки и звуковых эффектов.
///
/// Без рекламы и внешних ссылок. Все ассеты локальные.
class AudioService {
  AudioService()
      : _sfx = AudioPlayer(),
        _music = ja.AudioPlayer();

  final AudioPlayer _sfx;
  final ja.AudioPlayer _music;

  bool soundEnabled = true;
  bool musicEnabled = true;

  /// Проигрывает короткий SFX из assets.
  Future<void> playSfx(String assetPath) async {
    if (!soundEnabled) return;
    try {
      await _sfx.play(AssetSource(assetPath.replaceFirst('assets/', '')));
    } catch (e, st) {
      AppLogger.d('SFX skipped: $assetPath', e, st);
    }
  }

  /// Успешное чтение.
  Future<void> playSuccess() => playSfx('audio/sfx/success.mp3');

  /// Награда / уровень.
  Future<void> playReward() => playSfx('audio/sfx/reward.mp3');

  /// Клик UI.
  Future<void> playClick() => playSfx('audio/sfx/click.mp3');

  /// Запускает зацикленную музыку локации.
  Future<void> playMusic(String assetPath, {double volume = 0.45}) async {
    if (!musicEnabled) return;
    try {
      await _music.setAsset(assetPath);
      await _music.setLoopMode(ja.LoopMode.one);
      await _music.setVolume(volume);
      await _music.play();
    } catch (e, st) {
      AppLogger.d('Music skipped: $assetPath', e, st);
    }
  }

  /// Останавливает музыку.
  Future<void> stopMusic() async {
    try {
      await _music.stop();
    } catch (_) {}
  }

  /// Пауза музыки.
  Future<void> pauseMusic() async {
    try {
      await _music.pause();
    } catch (_) {}
  }

  /// Освобождает ресурсы.
  Future<void> dispose() async {
    await _sfx.dispose();
    await _music.dispose();
  }
}
