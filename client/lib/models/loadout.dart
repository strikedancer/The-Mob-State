class Loadout {
  final int id;
  final int playerId;
  final String name;
  final String? description;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<LoadoutTool> tools;

  Loadout({
    required this.id,
    required this.playerId,
    required this.name,
    this.description,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.tools,
  });

  factory Loadout.fromJson(Map<String, dynamic> json) {
    return Loadout(
      id: json['id'] as int,
      playerId: json['playerId'] as int,
      name: json['name'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      tools: (json['tools'] as List)
          .map((tool) => LoadoutTool.fromJson(tool))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'playerId': playerId,
      'name': name,
      'description': description,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'tools': tools.map((t) => t.toJson()).toList(),
    };
  }

  int get toolCount => tools.length;
}

class LoadoutTool {
  final String toolId;
  final int slotPosition;

  LoadoutTool({
    required this.toolId,
    required this.slotPosition,
  });

  factory LoadoutTool.fromJson(Map<String, dynamic> json) {
    return LoadoutTool(
      toolId: json['toolId'] as String,
      slotPosition: json['slotPosition'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'toolId': toolId,
      'slotPosition': slotPosition,
    };
  }
}
