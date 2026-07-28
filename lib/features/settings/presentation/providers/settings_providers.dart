import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:readquest/core/constants/game_constants.dart';
import 'package:readquest/core/di/app_dependencies.dart';
import 'package:readquest/features/settings/domain/entities/app_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Notifier настроек приложения.
class AppSettingsNotifier extends StateNotifier<AppSettings> {
  AppSettingsNotifier(this._prefs) : super(const AppSettings()) {
    _load();
  }

  final SharedPreferences _prefs;

  void _load() {
    state = AppSettings(
      playerName: _prefs.getString(StorageKeys.playerName) ?? '',
      onboardingComplete:
          _prefs.getBool(StorageKeys.onboardingComplete) ?? false,
      soundEnabled: _prefs.getBool(StorageKeys.soundEnabled) ?? true,
      musicEnabled: _prefs.getBool(StorageKeys.musicEnabled) ?? true,
      ttsEnabled: _prefs.getBool(StorageKeys.ttsEnabled) ?? true,
      ttsRate: _prefs.getDouble(StorageKeys.ttsRate) ?? 0.45,
      largeText: _prefs.getBool(StorageKeys.largeText) ?? false,
      highContrast: _prefs.getBool(StorageKeys.highContrast) ?? false,
      openDyslexic: _prefs.getBool(StorageKeys.openDyslexic) ?? false,
      animationSpeed: _prefs.getDouble(StorageKeys.animationSpeed) ?? 1.0,
      parentPinHash: _prefs.getString(StorageKeys.parentPinHash),
    );
  }

  /// Сохраняет имя игрока.
  Future<void> setPlayerName(String name) async {
    await _prefs.setString(StorageKeys.playerName, name);
    state = state.copyWith(playerName: name);
  }

  /// Завершает онбординг.
  Future<void> completeOnboarding() async {
    await _prefs.setBool(StorageKeys.onboardingComplete, true);
    state = state.copyWith(onboardingComplete: true);
  }

  /// Переключает звук.
  Future<void> setSoundEnabled(bool value) async {
    await _prefs.setBool(StorageKeys.soundEnabled, value);
    state = state.copyWith(soundEnabled: value);
  }

  /// Переключает музыку.
  Future<void> setMusicEnabled(bool value) async {
    await _prefs.setBool(StorageKeys.musicEnabled, value);
    state = state.copyWith(musicEnabled: value);
  }

  /// Переключает озвучивание.
  Future<void> setTtsEnabled(bool value) async {
    await _prefs.setBool(StorageKeys.ttsEnabled, value);
    state = state.copyWith(ttsEnabled: value);
  }

  /// Задаёт скорость TTS.
  Future<void> setTtsRate(double value) async {
    await _prefs.setDouble(StorageKeys.ttsRate, value);
    state = state.copyWith(ttsRate: value);
  }

  /// Крупный текст.
  Future<void> setLargeText(bool value) async {
    await _prefs.setBool(StorageKeys.largeText, value);
    state = state.copyWith(largeText: value);
  }

  /// Высокий контраст.
  Future<void> setHighContrast(bool value) async {
    await _prefs.setBool(StorageKeys.highContrast, value);
    state = state.copyWith(highContrast: value);
  }

  /// Шрифт OpenDyslexic.
  Future<void> setOpenDyslexic(bool value) async {
    await _prefs.setBool(StorageKeys.openDyslexic, value);
    state = state.copyWith(openDyslexic: value);
  }

  /// Скорость анимаций (0.5–1.5).
  Future<void> setAnimationSpeed(double value) async {
    final clamped = value.clamp(0.5, 1.5);
    await _prefs.setDouble(StorageKeys.animationSpeed, clamped);
    state = state.copyWith(animationSpeed: clamped);
  }

  /// Устанавливает хеш PIN.
  Future<void> setParentPinHash(String hash) async {
    await _prefs.setString(StorageKeys.parentPinHash, hash);
    state = state.copyWith(parentPinHash: hash);
  }
}

/// Provider настроек.
final appSettingsProvider =
    StateNotifierProvider<AppSettingsNotifier, AppSettings>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AppSettingsNotifier(prefs);
});
