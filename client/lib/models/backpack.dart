import 'package:json_annotation/json_annotation.dart';

part 'backpack.g.dart';

@JsonSerializable()
class Backpack {
  final String id;
  final String name;
  final String description;
  final String type;
  final int slots;
  final int price;
  final int requiredRank;
  final bool vipOnly;
  final String icon;

  Backpack({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.slots,
    required this.price,
    required this.requiredRank,
    required this.vipOnly,
    required this.icon,
  });

  factory Backpack.fromJson(Map<String, dynamic> json) =>
      _$BackpackFromJson(json);

  Map<String, dynamic> toJson() => _$BackpackToJson(this);
}

@JsonSerializable()
class PlayerBackpack {
  final int id;
  final int playerId;
  final String backpackId;
  final DateTime purchasedAt;
  final Backpack? backpack;

  PlayerBackpack({
    required this.id,
    required this.playerId,
    required this.backpackId,
    required this.purchasedAt,
    this.backpack,
  });

  factory PlayerBackpack.fromJson(Map<String, dynamic> json) =>
      _$PlayerBackpackFromJson(json);

  Map<String, dynamic> toJson() => _$PlayerBackpackToJson(this);
}

@JsonSerializable()
class BackpackCapacity {
  final int capacity;
  final int base;
  final int bonus;

  BackpackCapacity({
    required this.capacity,
    required this.base,
    required this.bonus,
  });

  factory BackpackCapacity.fromJson(Map<String, dynamic> json) =>
      _$BackpackCapacityFromJson(json);

  Map<String, dynamic> toJson() => _$BackpackCapacityToJson(this);
}

@JsonSerializable()
class AvailableBackpacksResponse {
  final Backpack? owned;
  final List<Backpack> available;
  final List<Backpack> canUpgradeTo;

  AvailableBackpacksResponse({
    this.owned,
    required this.available,
    required this.canUpgradeTo,
  });

  factory AvailableBackpacksResponse.fromJson(Map<String, dynamic> json) =>
      _$AvailableBackpacksResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AvailableBackpacksResponseToJson(this);
}
