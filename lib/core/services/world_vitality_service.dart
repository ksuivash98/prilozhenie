import 'package:readquest/core/config/app_config.dart';
import 'package:readquest/features/world/domain/entities/world_state.dart';

/// Сервис «живого мира»: чтение оживляет, бездействие сереет.
class WorldVitalityService {
  /// Пересчитывает vitality с учётом времени без чтения.
  WorldState applyTimeDecay(WorldState state, {DateTime? now}) {
    final moment = now ?? DateTime.now();
    final hours = moment.difference(state.lastReadAt).inHours;
    if (hours < AppConfig.worldFadeHours) return state;

    final fadeRange = AppConfig.worldGrayHours - AppConfig.worldFadeHours;
    final overdue = (hours - AppConfig.worldFadeHours).clamp(0, fadeRange);
    final decay = overdue / fadeRange;
    final score = (state.vitalityScore * (1 - decay * 0.7)).clamp(0.05, 1.0);

    return state.copyWith(vitalityScore: score);
  }

  /// Усиливает мир после успешного чтения [wordsCount] слов.
  WorldState onWordsRead(WorldState state, int wordsCount, {DateTime? now}) {
    final boost = (0.02 * wordsCount).clamp(0.02, 0.25);
    final score = (state.vitalityScore + boost).clamp(0.0, 1.0);
    final effects = {...state.restoredEffects};

    if (score >= 0.3) effects.add(WorldEffect.fogClears.name);
    if (score >= 0.4) effects.add(WorldEffect.flowersBloom.name);
    if (score >= 0.5) effects.add(WorldEffect.birdsReturn.name);
    if (score >= 0.6) effects.add(WorldEffect.butterflies.name);
    if (score >= 0.7) effects.add(WorldEffect.treesAwaken.name);
    if (score >= 0.8) effects.add(WorldEffect.housesBuild.name);
    if (score >= 0.9) effects.add(WorldEffect.villagersAppear.name);
    if (score >= 0.95) effects.add(WorldEffect.rainbow.name);

    return state.copyWith(
      vitalityScore: score,
      lastReadAt: now ?? DateTime.now(),
      restoredEffects: effects,
      totalWordsRead: state.totalWordsRead + wordsCount,
    );
  }

  /// Разблокирует следующую локацию по сюжету.
  WorldState unlockNextLocation(WorldState state, String locationId) {
    return state.copyWith(
      unlockedLocationIds: {...state.unlockedLocationIds, locationId},
    );
  }
}
