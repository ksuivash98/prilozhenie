/// Контракт маппера между слоями Data и Domain.
abstract interface class Mapper<Entity, Model> {
  /// Преобразует модель данных в доменную сущность.
  Entity toEntity(Model model);

  /// Преобразует доменную сущность в модель данных.
  Model toModel(Entity entity);

  /// Преобразует список моделей.
  List<Entity> toEntityList(List<Model> models) =>
      models.map(toEntity).toList(growable: false);

  /// Преобразует список сущностей.
  List<Model> toModelList(List<Entity> entities) =>
      entities.map(toModel).toList(growable: false);
}
