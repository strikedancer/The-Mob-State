/// Server payload from GET /market/unified (`itemListings`) and my-listings.
class PlayerToolMarketListing {
  final int listingId;
  final String kind;
  final int price;
  final String? countryCode;
  final DateTime createdAt;
  final int sellerId;
  final String sellerUsername;
  final PlayerToolMarketPlayerTool playerTool;
  final PlayerToolMarketToolDefinition? toolDefinition;

  PlayerToolMarketListing({
    required this.listingId,
    required this.kind,
    required this.price,
    required this.countryCode,
    required this.createdAt,
    required this.sellerId,
    required this.sellerUsername,
    required this.playerTool,
    required this.toolDefinition,
  });

  factory PlayerToolMarketListing.fromJson(Map<String, dynamic> json) {
    final seller = json['seller'] as Map<String, dynamic>?;
    final pt = json['playerTool'] as Map<String, dynamic>?;
    final td = json['toolDefinition'] as Map<String, dynamic>?;
    return PlayerToolMarketListing(
      listingId: (json['listingId'] as num).toInt(),
      kind: json['kind'] as String? ?? 'player_tool',
      price: (json['price'] as num).toInt(),
      countryCode: json['countryCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sellerId: (seller?['id'] as num?)?.toInt() ?? 0,
      sellerUsername: seller?['username'] as String? ?? '',
      playerTool: pt != null
          ? PlayerToolMarketPlayerTool.fromJson(pt)
          : PlayerToolMarketPlayerTool(
              id: 0,
              toolId: '',
              durability: 0,
              location: '',
              quantity: 0,
            ),
      toolDefinition: td != null
          ? PlayerToolMarketToolDefinition.fromJson(td)
          : null,
    );
  }

  String get displayName =>
      toolDefinition?.name ?? playerTool.toolId;
}

class PlayerToolMarketPlayerTool {
  final int id;
  final String toolId;
  final int durability;
  final String location;
  final int quantity;

  PlayerToolMarketPlayerTool({
    required this.id,
    required this.toolId,
    required this.durability,
    required this.location,
    required this.quantity,
  });

  factory PlayerToolMarketPlayerTool.fromJson(Map<String, dynamic> json) {
    return PlayerToolMarketPlayerTool(
      id: (json['id'] as num).toInt(),
      toolId: json['toolId'] as String,
      durability: (json['durability'] as num).toInt(),
      location: json['location'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );
  }
}

class PlayerToolMarketToolDefinition {
  final String id;
  final String name;
  final String type;
  final int basePrice;
  final int maxDurability;

  PlayerToolMarketToolDefinition({
    required this.id,
    required this.name,
    required this.type,
    required this.basePrice,
    required this.maxDurability,
  });

  factory PlayerToolMarketToolDefinition.fromJson(Map<String, dynamic> json) {
    return PlayerToolMarketToolDefinition(
      id: json['id'].toString(),
      name: json['name'] as String,
      type: json['type'] as String,
      basePrice: (json['basePrice'] as num).toInt(),
      maxDurability: (json['maxDurability'] as num).toInt(),
    );
  }
}
