/// Server payload from GET /market/unified (`itemListings`) and my-listings.
class PlayerToolMarketListing {
  final int listingId;
  final String kind;
  final int price;
  final int quantity;
  final String? countryCode;
  final DateTime createdAt;
  final int sellerId;
  final String sellerUsername;
  final PlayerToolMarketPlayerTool? playerTool;
  final PlayerToolMarketToolDefinition? toolDefinition;
  final DrugLotInfo? drugLot;
  final CryptoLotInfo? cryptoLot;
  final TradeGoodLotInfo? tradeGoodLot;
  final EventItemLotInfo? eventItemLot;

  PlayerToolMarketListing({
    required this.listingId,
    required this.kind,
    required this.price,
    required this.quantity,
    required this.countryCode,
    required this.createdAt,
    required this.sellerId,
    required this.sellerUsername,
    this.playerTool,
    this.toolDefinition,
    this.drugLot,
    this.cryptoLot,
    this.tradeGoodLot,
    this.eventItemLot,
  });

  factory PlayerToolMarketListing.fromJson(Map<String, dynamic> json) {
    final seller = json['seller'] as Map<String, dynamic>?;
    final pt = json['playerTool'] as Map<String, dynamic>?;
    final td = json['toolDefinition'] as Map<String, dynamic>?;
    final drug = json['drugLot'] as Map<String, dynamic>?;
    final crypto = json['cryptoLot'] as Map<String, dynamic>?;
    final trade = json['tradeGoodLot'] as Map<String, dynamic>?;
    final eventItem = json['eventItemLot'] as Map<String, dynamic>?;
    return PlayerToolMarketListing(
      listingId: (json['listingId'] as num).toInt(),
      kind: json['kind'] as String? ?? 'player_tool',
      price: (json['price'] as num).toInt(),
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      countryCode: json['countryCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      sellerId: (seller?['id'] as num?)?.toInt() ?? 0,
      sellerUsername: seller?['username'] as String? ?? '',
      playerTool: pt != null ? PlayerToolMarketPlayerTool.fromJson(pt) : null,
      toolDefinition:
          td != null ? PlayerToolMarketToolDefinition.fromJson(td) : null,
      drugLot: drug != null ? DrugLotInfo.fromJson(drug) : null,
      cryptoLot: crypto != null ? CryptoLotInfo.fromJson(crypto) : null,
      tradeGoodLot: trade != null ? TradeGoodLotInfo.fromJson(trade) : null,
      eventItemLot:
          eventItem != null ? EventItemLotInfo.fromJson(eventItem) : null,
    );
  }

  String get displayName {
    switch (kind) {
      case 'drug_lot':
        return drugLot != null
            ? '${drugLot!.drugName} (${drugLot!.qualityLabel})'
            : 'Drug lot';
      case 'crypto_lot':
        return cryptoLot?.assetSymbol ?? 'Crypto';
      case 'trade_good_lot':
        return tradeGoodLot?.goodName ?? 'Trade good';
      case 'event_item':
        return eventItemLot?.nameEn ?? 'Event item';
      default:
        return toolDefinition?.name ?? playerTool?.toolId ?? 'Item';
    }
  }

  String get subtitle {
    switch (kind) {
      case 'drug_lot':
        return '${drugLot?.quantity ?? quantity}g';
      case 'crypto_lot':
        return cryptoLot?.quantity ?? '';
      case 'trade_good_lot':
        return 'x${tradeGoodLot?.quantity ?? quantity}';
      case 'event_item':
        return 'x${eventItemLot?.quantity ?? quantity}';
      default:
        final pt = playerTool;
        if (pt == null) return '';
        return 'Qty ${pt.quantity} • ${pt.durability}%';
    }
  }
}

class DrugLotInfo {
  final String drugType;
  final String drugName;
  final String quality;
  final String qualityLabel;
  final int unitPrice;
  final int quantity;

  DrugLotInfo({
    required this.drugType,
    required this.drugName,
    required this.quality,
    required this.qualityLabel,
    required this.unitPrice,
    required this.quantity,
  });

  factory DrugLotInfo.fromJson(Map<String, dynamic> json) {
    return DrugLotInfo(
      drugType: json['drugType']?.toString() ?? '',
      drugName: json['drugName']?.toString() ?? '',
      quality: json['quality']?.toString() ?? 'C',
      qualityLabel: json['qualityLabel']?.toString() ?? 'C',
      unitPrice: (json['unitPrice'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
}

class CryptoLotInfo {
  final String assetSymbol;
  final String quantity;
  final String avgBuyPrice;

  CryptoLotInfo({
    required this.assetSymbol,
    required this.quantity,
    required this.avgBuyPrice,
  });

  factory CryptoLotInfo.fromJson(Map<String, dynamic> json) {
    return CryptoLotInfo(
      assetSymbol: json['assetSymbol']?.toString() ?? '',
      quantity: json['quantity']?.toString() ?? '0',
      avgBuyPrice: json['avgBuyPrice']?.toString() ?? '0',
    );
  }
}

class TradeGoodLotInfo {
  final String goodType;
  final String goodName;
  final int condition;
  final int quantity;
  final int unitBasePrice;

  TradeGoodLotInfo({
    required this.goodType,
    required this.goodName,
    required this.condition,
    required this.quantity,
    required this.unitBasePrice,
  });

  factory TradeGoodLotInfo.fromJson(Map<String, dynamic> json) {
    return TradeGoodLotInfo(
      goodType: json['goodType']?.toString() ?? '',
      goodName: json['goodName']?.toString() ?? '',
      condition: (json['condition'] as num?)?.toInt() ?? 100,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitBasePrice: (json['unitBasePrice'] as num?)?.toInt() ?? 0,
    );
  }
}

class EventItemLotInfo {
  final String itemKey;
  final String nameEn;
  final String nameNl;
  final int unitPrice;
  final int quantity;

  EventItemLotInfo({
    required this.itemKey,
    required this.nameEn,
    required this.nameNl,
    required this.unitPrice,
    required this.quantity,
  });

  factory EventItemLotInfo.fromJson(Map<String, dynamic> json) {
    return EventItemLotInfo(
      itemKey: json['itemKey']?.toString() ?? '',
      nameEn: json['nameEn']?.toString() ?? '',
      nameNl: json['nameNl']?.toString() ?? '',
      unitPrice: (json['unitPrice'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
    );
  }
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
