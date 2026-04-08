import 'package:json_annotation/json_annotation.dart';
import 'crew_member.dart';

part 'crew.g.dart';

@JsonSerializable()
class Crew {
  final int id;
  final String name;
  final int bankBalance;
  final String createdAt;
  final String? hqStyle;
  final int? hqLevel;
  final bool isVip;
  final String? vipExpiresAt;
  final List<CrewMember> members;

  Crew({
    required this.id,
    required this.name,
    required this.bankBalance,
    required this.createdAt,
    this.hqStyle,
    this.hqLevel,
    this.isVip = false,
    this.vipExpiresAt,
    required this.members,
  });

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);
  Map<String, dynamic> toJson() => _$CrewToJson(this);

  CrewMember? get leader {
    if (members.isEmpty) return null;
    return members.firstWhere(
      (m) => m.role == 'leader',
      orElse: () => members.first,
    );
  }

  int get memberCount => members.length;
}
