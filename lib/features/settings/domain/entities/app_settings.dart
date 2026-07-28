import 'package:equatable/equatable.dart';

/// Настройки приложения и доступности.
class AppSettings extends Equatable {
  const AppSettings({
    this.playerName = '',
    this.onboardingComplete = false,
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.ttsEnabled = true,
    this.ttsRate = 0.45,
    this.largeText = false,
    this.highContrast = false,
    this.openDyslexic = false,
    this.animationSpeed = 1.0,
    this.parentPinHash,
  });

  final String playerName;
  final bool onboardingComplete;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool ttsEnabled;
  final double ttsRate;
  final bool largeText;
  final bool highContrast;
  final bool openDyslexic;

  /// 0.5 = медленнее, 1.0 = норма, 1.5 = быстрее.
  final double animationSpeed;
  final String? parentPinHash;

  /// Копия с изменениями.
  AppSettings copyWith({
    String? playerName,
    bool? onboardingComplete,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? ttsEnabled,
    double? ttsRate,
    bool? largeText,
    bool? highContrast,
    bool? openDyslexic,
    double? animationSpeed,
    String? parentPinHash,
    bool clearPin = false,
  }) {
    return AppSettings(
      playerName: playerName ?? this.playerName,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      ttsEnabled: ttsEnabled ?? this.ttsEnabled,
      ttsRate: ttsRate ?? this.ttsRate,
      largeText: largeText ?? this.largeText,
      highContrast: highContrast ?? this.highContrast,
      openDyslexic: openDyslexic ?? this.openDyslexic,
      animationSpeed: animationSpeed ?? this.animationSpeed,
      parentPinHash: clearPin ? null : (parentPinHash ?? this.parentPinHash),
    );
  }

  /// Есть ли установленный родительский PIN.
  bool get hasParentPin => parentPinHash != null && parentPinHash!.isNotEmpty;

  @override
  List<Object?> get props => [
        playerName,
        onboardingComplete,
        soundEnabled,
        musicEnabled,
        ttsEnabled,
        ttsRate,
        largeText,
        highContrast,
        openDyslexic,
        animationSpeed,
        parentPinHash,
      ];
}
