import 'package:equatable/equatable.dart';

/// Тип предмета инвентаря.
enum ItemType {
  currency,
  food,
  key,
  collectible,
  dragonCosmetic,
  chest,
  potion,
}

/// Предмет инвентаря.
class InventoryItem extends Equatable {
  const InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.quantity,
    this.rarity = 'common',
    this.iconKey = 'item',
  });

  final String id;
  final String name;
  final String description;
  final ItemType type;
  final int quantity;
  final String rarity;
  final String iconKey;

  InventoryItem copyWith({int? quantity}) {
    return InventoryItem(
      id: id,
      name: name,
      description: description,
      type: type,
      quantity: quantity ?? this.quantity,
      rarity: rarity,
      iconKey: iconKey,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'type': type.name,
        'quantity': quantity,
        'rarity': rarity,
        'iconKey': iconKey,
      };

  factory InventoryItem.fromMap(Map<dynamic, dynamic> map) {
    return InventoryItem(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      description: map['description'] as String? ?? '',
      type: ItemType.values.firstWhere(
        (t) => t.name == map['type'],
        orElse: () => ItemType.collectible,
      ),
      quantity: map['quantity'] as int? ?? 0,
      rarity: map['rarity'] as String? ?? 'common',
      iconKey: map['iconKey'] as String? ?? 'item',
    );
  }

  @override
  List<Object?> get props => [id, type, quantity];
}

/// Инвентарь игрока.
class Inventory extends Equatable {
  const Inventory({
    required this.items,
    required this.coins,
    required this.gems,
  });

  final List<InventoryItem> items;
  final int coins;
  final int gems;

  factory Inventory.initial() {
    return const Inventory(
      items: [],
      coins: 0,
      gems: 0,
    );
  }

  Inventory copyWith({
    List<InventoryItem>? items,
    int? coins,
    int? gems,
  }) {
    return Inventory(
      items: items ?? this.items,
      coins: coins ?? this.coins,
      gems: gems ?? this.gems,
    );
  }

  Map<String, dynamic> toMap() => {
        'items': items.map((e) => e.toMap()).toList(),
        'coins': coins,
        'gems': gems,
      };

  factory Inventory.fromMap(Map<dynamic, dynamic> map) {
    final rawItems = map['items'] as List<dynamic>? ?? const [];
    return Inventory(
      items: rawItems
          .map((e) => InventoryItem.fromMap(e as Map<dynamic, dynamic>))
          .toList(),
      coins: map['coins'] as int? ?? 0,
      gems: map['gems'] as int? ?? 0,
    );
  }

  @override
  List<Object?> get props => [items, coins, gems];
}
